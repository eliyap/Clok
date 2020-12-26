//
//  RepresentativeNeedsUpdate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData

extension ClokRequest {
    
    static let RepresentativeNeedsUpdate: NSFetchRequest<NSFetchRequestResult> = {
        
        let marker = WorkspaceManager.lastIndexedRepresentatives
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        
        /// cap the number of entries operated on at once
        req.fetchLimit = Self.representativeIndexCount
        
        /// filter for entries look for updated since last time
        req.predicate = NSPredicate(
            format: "(lastUpdated >= %@) AND (id > %d)",
            NSDate(marker.lastIndexed),
            marker.id
        )
        
        /// sort by `.lastUpdated`, then `.id`
        req.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: true),
            NSSortDescriptor(key: "id", ascending: true)
        ]
        
        return req
    }()
}
