//
//  RecursiveLoader.swift
//  Clok
//
// Based on:
// https://www.donnywals.com/recursively-execute-a-paginated-network-call-with-combine/

import Foundation
import Combine
import CoreData

fileprivate struct PagedReport {
    /// the `Report` struct decoded
    let report: Report
    
    /// the page no. of the detailed report this `Report` represents
    let index: Int
}

struct Item {}

class RecursiveLoader {
    init() { }
    /**
     Requests a specific page of a Detailed Report
     - Parameters:
        - index: which page is being requested. Zero indexed.
        - api_string: URL path plus some necessary info to form the request. Missing the page number.
        - auth: string authenticating the request
     - Returns: the `Report` struct bundled with the `index`
     */
    private func loadPage(
        index: Int,
        api_string: String,
        auth: String
    ) -> AnyPublisher<PagedReport, Error> {
        // this would be the individual network call
        #warning("placeholder request!")
        let request = formRequest(
            /// NOTE: pages are 1 indexed
            url: URL(string: api_string + "&page=\(index + 1)")!,
            auth: auth
        )
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Report.self, decoder: JSONDecoder())
            .map { PagedReport(report: $0, index: index) }
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
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(0)

        return pageIndexPublisher
            .flatMap({ index in
                return self.loadPage(index: index, api_string: api_string, auth: auth)
            })
            .handleEvents(receiveOutput: { (page: PagedReport) in
                guard
                    /// if request yielded no entries, terminate
                    page.report.entries.count != 0,
                    /// if `totalCount` has been met, terminate
                    page.report.totalCount > page.index * togglPageSize + page.report.entries.count
                else {
                    pageIndexPublisher.send(completion: .finished)
                    return
                }
                /// request next page
                pageIndexPublisher.send(page.index + 1)
                
            })
            .reduce([RawTimeEntry](), { entries, page in
                return entries + page.report.entries
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

