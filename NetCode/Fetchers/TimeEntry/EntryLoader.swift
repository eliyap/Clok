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
    private var loader: AnyCancellable? = nil
    
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
    
    func fetchEntries(
        range: DateRange,
        user: User,
        projects: [Project],
        tags: [Tag],
        context: NSManagedObjectContext,
        initialLogin: Bool = false
    ) -> Void {
        /// begin loading animations
        withAnimation {
            state = initialLogin ? .loadingLengthy : .loadingBriefly
        }
        
        // assemble request URL (page is added later)
        // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
        let api_string = "\(NetworkConstants.REPORT_URL)details?" + [
            "user_agent=\(NetworkConstants.user_agent)",    // identifies my app
            "workspace_id=\(user.chosen.wid)", // provided by the User
            "since=\(range.start.iso8601day)",
            "until=\(range.end.iso8601day)"
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
                var toDelete = context.loadEntries(in: range) ?? []
                
                /// perform matching between new and stored data
                rawEntries.forEach { (rawEntry: RawTimeEntry) in
                    /// spare any entries that are still in the raw data
                    if let entryIdx = toDelete.firstIndex(where: {$0.id == rawEntry.id}) {
                        toDelete.remove(at: entryIdx)
                    }
                    /// insert raw entry. Don't worry about conflicts since `CoreData` does uniquing
                    context.insert(TimeEntry(from: rawEntry, context: context, projects: projects, tags: tags))
                }
                /**
                 Remaining `TimeEntry`s had no match in the fetched data.
                 Hence they must have been deleted, so we will delete them in CoreData as well.
                 */
                for deletedEntry in toDelete {
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
