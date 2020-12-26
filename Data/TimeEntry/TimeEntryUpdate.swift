//
//  TimeEntryUpdate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension TimeEntry {
    
    /// Take user's local changes and place them into `CoreData` storage
    /// - Parameters:
    ///   - model: `EntryModel` containing new, user edited details
    ///   - tags: `Tag` objects to match names against
    func update(from model: EntryModel, tags: FetchedResults<Tag>) -> Void {
        
        self.start = model.start
        self.end = model.end
        self.billable = model.billable
        self.name = model.entryDescription
        self.tags = Set(tags.filter {
            model.tagStrings.contains($0.name)
        }) as NSSet
        
        /// remember to update duration calculation
        self.dur = end - start
        
        switch model.project {
        case .project(let project):
            self.project = project
        case .special(.NoProject):
            self.project = nil
        case .special(_):
            fatalError("Tried to store StaticProject!")
        case .lite(_):
            fatalError("Tried to store LiteProject!")
        }
    }
    
    /// After updating Toggl's service on the user's changes, Toggl replies with it's new understanding of the `TimeEntry`.
    /// This function integrates Toggl's authoritative understanding into our own `CoreData` object.
    /// - Parameter updated: Toggl's new understanding of our object
    func update(from updated: UpdatedEntry) {
        /// this is a fatal error, do not proceed if the `id` got messed up
        precondition(updated.data.id == self.id)
        
        /// Toggl tells us the new updated timestamp, accept ths unconditionally
        self.lastUpdated = updated.data.at
        
        //MARK:- Checks
        /// `assert` that everything else was as we left it, there should be no surprises here
        /// check on duration calculation
        do {
            try check_equal(updated.data.duration, updated.data.stop - updated.data.start)
            try check_equal(self.start, updated.data.start)
            try check_equal(self.end, updated.data.stop)
            try check_equal(self.billable, updated.data.billable)
            try check_equal(self.dur, updated.data.duration)
            try check_equal(self.tagStrings.sorted(), updated.data.tags?.sorted() ?? [])
            if self.project?.id != updated.data.pid {
                throw EqualityError.unequal
            }
        } catch {
            /// if there is any disagreement, dump the contrasting information, then crash
            #if DEBUG
            print(self)
            print(updated.data)
            #endif
            assert(false)
        }
    }
}
