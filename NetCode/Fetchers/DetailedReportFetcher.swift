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
            /// publish updates on main thread
            .receive(on: DispatchQueue.main)
            .handleEvents( receiveOutput: { (report, pageNo) in
                /// report the expected total entries
                self.totalCount = report.totalCount
                
                /// calculate total number of loaded entries so far
                let loaded = (pageNo - 1) * togglPageSize + report.entries.count
                self.loaded = loaded
            })
            /// send back to background thread
            .receive(on: DispatchQueue.global(qos: .background))
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
}
