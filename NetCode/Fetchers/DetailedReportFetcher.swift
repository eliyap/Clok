//
//  DetailedReportFetcher.swift
//  WidgetBundleExtension
//
//  Created by Secret Asian Man Dev on 28/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

extension DataFetcher {
    
    func fetchDetailedReport(
        token: String,
        wid: Int,
        period: Period,
        completion:@escaping (Detailed?, Error?) -> Void
    ) -> Void {
        
        /// determine start date based on user preference
        var start = Date().midnight
        switch period {
        case .day, .unknown: /// if unknown, default to 1 day
            start = start.advanced(by: -.day)
        case .week:
            start = start.advanced(by: -.week)
        }
        
        // assemble request URL (page is added later)
        // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
        let api_string = "\(REPORT_URL)/details?" + [
            "user_agent=\(user_agent)",
            "workspace_id=\(wid)",
            /// cast 1 day into the past for roll-over entries
            "since=\(start.iso8601)",
            "until=\(Date().midnight.advanced(by: .day).iso8601)",
            /// **warning** ("only loads 1 page!")
            "page=0",
        ].joined(separator: "&")
        
        recursiveLoadPages(api_string: api_string, auth: auth(token: token))
            .map { (rawEntries: [RawTimeEntry]) -> Detailed? in
                return Detailed(entries: rawEntries, period: period)
            }
            .sink(receiveCompletion: { completed in
                switch completed {
                case .finished:
                    break
                case .failure(let error):
                    completion(nil, error)
                }
            }, receiveValue: { entry in
                completion(entry, nil)
            })
            .store(in: &cancellable)
    }
    
    /**
     Fetch a Detailed Report in multiple pages from Toggl
     - Parameters:
        - api_string: URL path plus some necessary info to form the request. Missing the page number.
        - auth: string authenticating the request
     - Returns: the `RawTimeEntries` fetched
     */
    func recursiveLoadPages(
        api_string: String,
        auth: String
    ) -> AnyPublisher<[RawTimeEntry], Error> {
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(1)

        return pageIndexPublisher
            .flatMap({ pageNo in
                return self.loadPage(pageNo: pageNo, api_string: api_string, auth: auth)
            })
            .handleEvents(receiveOutput: { (report, pageNo) in
                let loaded = (pageNo - 1) * togglPageSize + report.entries.count
                guard
                    /// if request yielded no entries, terminate
                    report.entries.count != 0,
                    /// if `totalCount` has been met, terminate
                    report.totalCount > loaded
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
            .eraseToAnyPublisher()
    }
    
    /**
     Bundle one page of a detailed report as a `Report` and its associated page no.
     - Page No. is indexed from 1
     */
    fileprivate typealias PagedReport = (report: Report, pageNo: Int)
    
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
            .map(dataTaskMonitor)
            .decode(type: Report.self, decoder: JSONDecoder(dateStrategy: .iso8601))
            .map { (report: Report) -> PagedReport in
                PagedReport(report: report, pageNo: pageNo)
            }
            .eraseToAnyPublisher()
    }
}