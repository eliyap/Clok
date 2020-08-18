//
//  PaginatedLoad.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 17/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

/**
 Bundle one page of a detailed report as a `Report` and its associated page no.
 - Page No. is indexed from 1
 */
fileprivate typealias PagedReport = (report: Report, pageNo: Int)

/**
 Code to perform the request for a Detailed Report over several URLSessions for the many pages
 */
extension EntryLoader {
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
            .map {
                let code = ($0.response as? HTTPURLResponse)?.statusCode
                print("map on page \(pageNo), response \(code ?? -1)")
                return $0.data
            }
            .decode(type: Report.self, decoder: JSONDecoder(dateStrategy: .iso8601))
            .map { (report: Report) -> PagedReport in
                PagedReport(report: report, pageNo: pageNo)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Fetch a Detailed Report in multiple pages from Toggl
     - Parameters:
        - api_string: URL path plus some necessary info to form the request. Missing the page number.
        - auth: string authenticating the request
     - Returns: the `RawTimeEntries` fetched
     */
    func recursiveLoadPages(
        projects: [Project],
        api_string: String,
        auth: String
    ) -> AnyPublisher<[RawTimeEntry], Error> {
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(1)

        return pageIndexPublisher
            .flatMap({ pageNo in
                return self.loadPage(pageNo: pageNo, api_string: api_string, auth: auth)
            })
            .handleEvents(receiveOutput: { (report, pageNo) in
                print("expecting \(report.totalCount)")
                guard
                    /// if request yielded no entries, terminate
                    report.entries.count != 0,
                    /// if `totalCount` has been met, terminate
                    report.totalCount > (pageNo - 1) * togglPageSize + report.entries.count
                else {
                    pageIndexPublisher.send(completion: .finished)
                    return
                }
                print("requesting page \(pageNo + 1)")
                /// request next page
                pageIndexPublisher.send(pageNo + 1)
            })
            .reduce([RawTimeEntry](), { entries, pagedReport in
                return entries + pagedReport.0.entries
            })
            .eraseToAnyPublisher()
    }
}
