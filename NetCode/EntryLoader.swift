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
    var entryLoader: AnyCancellable? = nil
    func fetchEntries(
        start: Date,
        end: Date,
        user: User,
        context: NSManagedObjectContext
    ) -> Void {
    //            /// switch to main thread before performing CoreData work
    //            .receive(on: DispatchQueue.main)
    //            .map { rawEntries in
    //                print("\(rawEntries.count) raw received")
    //                let entries = rawEntries.map { (rawEntry: RawTimeEntry) -> TimeEntry in
    //                    TimeEntry(from: rawEntry, context: context, projects: projects)
    //                }
    //                try! context.save()
    //                return entries
    //            }
    }
}
