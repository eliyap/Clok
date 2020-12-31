//
//  NoRepresentative.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData

extension ClokRequest {
    
    /// number of entries to index at once
    static let representativeIndexCount = 40
    
    static let NoRepresentative: NSFetchRequest<NSFetchRequestResult> = {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        /// cap the number of entries operated on at once
        req.fetchLimit = Self.representativeIndexCount
        /// filter for entries without a `TimeEntryRepresentative`
        req.predicate = NSPredicate(format: "representative == nil")
        return req
    }()
}
