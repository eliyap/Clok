//
//  RecursiveLoader.swift
//  Clok
//
// Based on:
// https://www.donnywals.com/recursively-execute-a-paginated-network-call-with-combine/

import Foundation
import Combine
import CoreData

/**
 Bundle one page of a detailed report as a `Report` and its associated page no.
 - Page No. is indexed from 1
 */
fileprivate typealias PagedReport = (report: Report, pageNo: Int)

struct Item {}

class RecursiveLoader {
    init() { }
    /**
     Requests a specific page of a Detailed Report
     - Parameters:
        - pageNo: which page is being requested. 1 indexed.
        - api_string: URL path plus some necessary info to form the request. Missing the page number.
        - auth: string authenticating the request
     - Returns: the `Report` struct bundled with the `index`
     */
    private func loadPage(
        pageNo: Int,
        api_string: String,
        auth: String
    ) -> AnyPublisher<(Report, Int), Error> {
        let request = formRequest(
            url: URL(string: api_string + "&page=\(pageNo)")!,
            auth: auth
        )
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Report.self, decoder: JSONDecoder())
            .map { (report: Report) -> PagedReport in
                PagedReport(report: report, pageNo: pageNo)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Fetch a Detailed Report in pages from Toggl
     - Parameters:
        - api_string: URL path plus some necessary info to form the request. Missing the page number.
        - auth: string authenticating the request
     - Returns: the `TimeEntries` fetched
     */
    func loadPages(
        context: NSManagedObjectContext,
        projects: [Project],
        api_string: String,
        auth: String
    ) -> AnyPublisher<[TimeEntry], Error> {
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(1)

        return pageIndexPublisher
            .flatMap({ pageNo in
                return self.loadPage(pageNo: pageNo, api_string: api_string, auth: auth)
            })
            .handleEvents(receiveOutput: { (report, pageNo) in
                guard
                    /// if request yielded no entries, terminate
                    report.entries.count != 0,
                    /// if `totalCount` has been met, terminate
                    report.totalCount > (pageNo - 1) * togglPageSize + report.entries.count
                else {
                    pageIndexPublisher.send(completion: .finished)
                    return
                }
                /// request next page
                pageIndexPublisher.send(pageNo + 1)
                
            })
            .reduce([RawTimeEntry](), { entries, pagedReport in
                return entries + pagedReport.0.entries
            })
            .receive(on: DispatchQueue.main)
            .map { rawEntries in
                let entries = rawEntries.map {
                    TimeEntry(from: $0, context: context, projects: projects)
                }
                try! context.save()
                return entries
            }
            .eraseToAnyPublisher()
    }
}

