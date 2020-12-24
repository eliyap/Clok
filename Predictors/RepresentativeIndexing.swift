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
            /// only fetch entries not already set
            req.predicate = NSPredicate(format: "representative == nil")
            guard let entries = try? context.fetch(req) else {
                assert(false, "Failed to fetch entries for indexing")
            }
            
        }
    }
    
    static func loadPopularRepresentatives(in context: NSManagedObjectContext) -> [TimeEntryRepresentative] {
        
    }
}
