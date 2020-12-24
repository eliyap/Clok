//
//  TimeEntry+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation
import SwiftUI
import CoreData

@objc(TimeEntry)
public class TimeEntry: NSManagedObject {
    
    static let entityName = "TimeEntry"
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(from raw: RawTimeEntry, context: NSManagedObjectContext, projects: [Project], tags: [Tag]) {
        super.init(entity: TimeEntry.entity(), insertInto: context)
        update(context: context, from: raw, projects: projects, tags: tags)
    }
    
    /// copy properties from raw time entry into TimeEntry
    func update(
        context: NSManagedObjectContext,
        from raw: RawTimeEntry,
        projects: [Project],
        tags: [Tag]
    ) {
        self.setValuesForKeys([
            "name": raw.description,
            "start": raw.start,
            "end": raw.end,
            "dur": raw.dur / 1000.0,
            "lastUpdated": raw.updated,
            "id": Int64(raw.id),
            "billable": raw.is_billable
        ])
        
        /// if no `pid` is provided, assume `NoProject`, aka `nil`
        /// NOTE: do NOT set to `NoProject`, which exists in a floating MOC
        if let pid = raw.pid {
            project = projects.first(where: {$0.id == pid})
        } else {
            project = nil
        }
        self.tags = Set(tags.filter {
            raw.tags.contains($0.name)
        }) as NSSet
    }
}
