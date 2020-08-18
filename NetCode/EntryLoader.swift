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

final class EntryLoader: ObservableObject {
    private var loader: AnyCancellable? = nil
    
    func fetchEntries(
        range: DateRange,
        user: User,
        projects: [Project],
        context: NSManagedObjectContext
    ) -> Void {
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
            projects: projects,
            api_string: api_string,
            auth: auth(token: user.token)
        )
            /// switch to main thread before performing CoreData work
            .receive(on: DispatchQueue.main)
            /// transform to Optional
            .map { (rawEntries: [RawTimeEntry]) -> [RawTimeEntry]? in
                return rawEntries
            }
            .catch({ error -> AnyPublisher<[RawTimeEntry]?, Never> in
                print(error)
                ///
                return Just(nil)
                    .eraseToAnyPublisher()
            })
            .sink(receiveValue: { (rawEntries: [RawTimeEntry]?) in
                /// terminate if error resulted in `nil` being passed
                guard let rawEntries = rawEntries else { return }
                
                rawEntries.forEach { (rawEntry: RawTimeEntry) in
                    context.insert(TimeEntry(from: rawEntry, context: context, projects: projects))
                }
                try! context.save()
            })
    }
}

/// fetch entries from Core Data storage
func loadEntries(
    from start: Date,
    to end: Date,
    context: NSManagedObjectContext
) -> [TimeEntry]? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
    fetchRequest.predicate = NSPredicate(
        format: "(end >= %@) AND (start <= %@)",
        NSDate(start),
        NSDate(end)
    )
    do {
        let entries = try context.fetch(fetchRequest) as! [TimeEntry]
        return entries
    } catch {
        print(error)
    }
    return nil
}
