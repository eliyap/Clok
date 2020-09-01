//
//  EntryLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 17/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData
import SwiftUI

final class EntryLoader: ObservableObject {
    var loader: AnyCancellable? = nil
    
    /// represents the state of the `EntryLoader`
    enum LoadState: Int {
        /// data is finished loading
        case finished
        
        /// short load for 1 week
        case loadingBriefly
        
        /// performing a long load at initial login
        case loadingLengthy
    }
    
    @Published var state = LoadState.finished
    @Published var totalCount = 0
    @Published var loaded = 0
    
    func fetchRawEntries(
        range: DateRange,
        user: User,
        projects: [Project],
        tags: [Tag],
        context: NSManagedObjectContext,
        initialLogin: Bool = false
    ) -> AnyPublisher<[RawTimeEntry]?, Never> {
        /// begin loading animations
        withAnimation {
            state = initialLogin ? .loadingLengthy : .loadingBriefly
        }
        
        // assemble request URL (page is added later)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
        
        // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
        let api_string = "\(REPORT_URL)details?" + [
            "user_agent=\(user_agent)",    // identifies my app
            "workspace_id=\(user.chosen.wid)", // provided by the User
            "since=\(df.string(from: range.start))",
            "until=\(df.string(from: range.end))"
        ].joined(separator: "&")
    
        loader = recursiveLoadPages(
            api_string: api_string,
            auth: auth(token: user.token)
        )
            /// switch to main thread before performing CoreData work
            .receive(on: DispatchQueue.main)
            .map(toOptional)
            .catch(printAndReturnNil)
            .sink(receiveValue: { (rawEntries: [RawTimeEntry]?) in
                /// terminate if error resulted in `nil` being passed
                guard let rawEntries = rawEntries else { return }
                
                /// fetch the CoreData records for this `DateRange`
                var entries = loadEntries(range: range, context: context)
                
                /// perform matching between new and stored data
                rawEntries.forEach { (rawEntry: RawTimeEntry) in
                    if let entryIdx = entries?.firstIndex(where: {$0.id == rawEntry.id}) {
                        /// if a matching `TimeEntry` was found, update the record
                        entries![entryIdx].update(from: rawEntry, projects: projects, tags: tags)
                        /// and remove it from future consideration
                        entries!.remove(at: entryIdx)
                    } else {
                        /// if no match was found, insert the new `TimeEntry`
                        context.insert(TimeEntry(from: rawEntry, context: context, projects: projects, tags: tags))
                    }
                }
                /**
                 Remaining `TimeEntry`s had no match in the fetched data.
                 Hence they must have been deleted, so we will delete them in CoreData as well.
                 */
                for deletedEntry in entries ?? [] {
                    context.delete(deletedEntry)
                }
                try! context.save()
                
                /// loading complete!
                withAnimation {
                    self.state = .finished
                }
            })
    }
}
