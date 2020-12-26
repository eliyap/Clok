//
//  RepresentativeIndexing.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData

extension TimeEntryIndexer {
    
    static func indexRepresentative(in context: NSManagedObjectContext) -> Void {
        guard let entries = Self.findEntries(in: context) else {
            assert(false, "Failed to fetch entries for indexing")
        }
        
        guard entries.count != 0 else {
            #if DEBUG
            print("All Entries have Representative indexed.")
            #endif
            return
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
        
        do {
            try context.save()
        } catch (let error) {
            print("Failed to save after indexing with error: \(error.localizedDescription)")
            print("Info: \((error as NSError).userInfo)")
            assert(false)
        }
        #if DEBUG
        print("Indexed Representatives for \(entries.count) entries")
        #endif
    }
    
    /// number of TimeEntryRepresentatives to allow into memory at once
    static let representativeCap = 25
    private static func loadPopularRepresentatives(in context: NSManagedObjectContext) -> [TimeEntryRepresentative] {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntryRepresentative.entityName)
        req.fetchLimit = Self.representativeCap
        /// filter to get the most popular entries
        /// NOTE: here is an excellent guide to understanding `SUBQUERY`: https://medium.com/@Czajnikowski/subquery-is-not-that-scary-3f95cb9e2d98
        req.sortDescriptors = [NSSortDescriptor(key: "representsCount", ascending: false)]
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
    private static func findMatch(to entry: TimeEntry, in context: NSManagedObjectContext) -> TimeEntryRepresentative? {
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
        do {
            if try context.count(for: ClokRequest.NoRepresentative) != 0 {
                return try context.fetch(ClokRequest.NoRepresentative) as? [TimeEntry]
            }
            
            /// if every entry has a `.representative`, look for those updated since last time
            let needUpdates = try context.fetch(ClokRequest.RepresentativeNeedsUpdate) as! [TimeEntry]
            
            /// if fetch was successful, set marker (have faith that all these will be successfully updated)
            if let last = needUpdates.last {
                WorkspaceManager.lastIndexedRepresentatives = RepresentativeMarker(id: last.id, lastIndexed: last.lastUpdated)
            }
            
            return needUpdates
        } catch {
            return nil
        }
    }
}
