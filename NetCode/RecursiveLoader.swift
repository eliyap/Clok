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

    private func loadPage(
        index: Int
    ) -> AnyPublisher<PagedReport, Error> {
        // this would be the individual network call
        #warning("placeholder request!")
        let request = formRequest(url: URL(string: "")!, auth: "")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Report.self, decoder: JSONDecoder())
            .map { PagedReport(report: $0, index: index) }
            .eraseToAnyPublisher()
    }
    
    func loadPages(context: NSManagedObjectContext) -> AnyPublisher<[TimeEntry], Error> {
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(0)

        return pageIndexPublisher
            .flatMap({ index in
                return self.loadPage(index: index)
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
            .map {
                $0.map {
                    TimeEntry(from: $0, context: context, projects: [])
                }
            }
            .eraseToAnyPublisher()
    }

}

