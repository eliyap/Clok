//
//  RepresentativeIndexing.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData

extension TimeEntryIndexer {
    
    /// number of entries to index at once
    static let representativeIndexCount = 200
    
    static func indexRepresentative(context: NSManagedObjectContext) -> Void {
        DispatchQueue.global(qos: .background).async {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
            
            /// cap the number of entries operated on at once
            req.fetchLimit = Self.representativeIndexCount
            
            /// fetch entries without a `TimeEntryRepresentative`, or who were updated since the last indexing
            req.predicate = NSPredicate(format: "representative == nil")
            
            guard let entries = try? context.fetch(req) as? [TimeEntry] else {
                assert(false, "Failed to fetch entries for indexing")
            }
            
            let popularRepresentatives = loadPopularRepresentatives(in: context)
            entries.forEach { entry in
                /// look for a `representative` in the most popular set
                if let match = popularRepresentatives.first(where: {$0.name == entry.name && $0.project == entry.project}) {
                    entry.representative = match
                }
                /// otherwise, search the entire storage for a match
                else if let match = findMatch(to: entry, in: context) {
                    entry.representative = match
                }
                /// if there is still no match, create a new `representative`
                else {
                    let match = TimeEntryRepresentative(in: context, name: entry.name, project: entry.project)
                    entry.representative = match
                }
            }
            
            /// move to main thread to save changes
            DispatchQueue.main.async {
                do { try context.save() }
                catch { assert(false, "Failed to save after indexing!") }
                #if DEBUG
                print("Indexed Representatives for \(entries.count) entries")
                #endif
            }
        }
    }
    
    /// number of TimeEntryRepresentatives to allow into memory at once
    static let representativeCap = 25
    static func loadPopularRepresentatives(in context: NSManagedObjectContext) -> [TimeEntryRepresentative] {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntryRepresentative.entityName)
        req.fetchLimit = Self.representativeCap
        /// filter to get the most popular entries
        req.sortDescriptors = [NSSortDescriptor(key: "represents.count", ascending: false)]
        guard let reps = try? context.fetch(req) else {
            assert(false, "Failed to fetch representatives!")
            return []
        }
        return reps as! [TimeEntryRepresentative]
    }
    
    
    /// Hits CoreData with a specific request for a `TimeEntryRepresentative`.
    /// Try to minimize use of this where possible.
    /// - Parameters:
    ///   - entry: `TimeEntry` we want represented
    ///   - context: persistent storage context
    /// - Returns: the matching `TimeEntryRepresentative`, if any
    static func findMatch(to entry: TimeEntry, in context: NSManagedObjectContext) -> TimeEntryRepresentative? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntryRepresentative.entityName)
        req.fetchLimit = 1
        
        /// set predicate based on possible nil values
        switch (entry.name, entry.project?.name) {
        case (.none, .none):
            req.predicate = NSPredicate(format: "(name == nil) AND (project.name == nil)")
        case (.none, .some(let projectName)):
            req.predicate = NSPredicate(format: "(name == nil) AND (project.name == %@)", projectName)
        case (.some(let name), .none):
            req.predicate = NSPredicate(format: "(name == %@) AND (project.name == nil)", name)
        case (.some(let name), .some(let projectName)):
            req.predicate = NSPredicate(format: "(name == %@) AND (project.name == %@)", name, projectName)
        }
        
        return context.max1(for: req)
    }
    
    private static func findEntries(in context: NSManagedObjectContext) -> [TimeEntry]? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        
        /// cap the number of entries operated on at once
        req.fetchLimit = Self.representativeIndexCount
        
        do {
            /// prioritize entries without a `TimeEntryRepresentative`
            req.predicate = NSPredicate(format: "representative == nil")
            if try context.count(for: req) != 0 {
                return try context.fetch(req) as? [TimeEntry]
            }
            /// if every entry has a `.representative`, look for those updated
            else {
                let marker = WorkspaceManager.lastIndexedRepresentatives
                req.predicate = NSPredicate(
                    format: "(updated >= %@) AND (id > %d)",
                    NSDate(marker.lastIndexed),
                    marker.id
                )
                /// sort by `.lastUpdated`, then `.id`
                req.sortDescriptors = [
                    NSSortDescriptor(key: "lastUpdated", ascending: true),
                    NSSortDescriptor(key: "id", ascending: true)
                ]
                return try context.fetch(req) as? [TimeEntry]
            }
        } catch {
            return nil
        }
    }
}
