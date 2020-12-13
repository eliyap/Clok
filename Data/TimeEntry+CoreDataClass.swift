//
//  TimeEntry+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation
import SwiftUI
import CoreData

struct RawTimeEntry: Decodable {
    let description: String
    
    let start: Date
    let end: Date
    let dur: Double
    let updated: Date
    
    let id: Int
    let is_billable: Bool
    
    let pid: Int?
    let project: String?
    let project_hex_color: String?
    
    let uid: Int; // user ID
    let use_stop: Bool
    let user: String
    let tags: [String]
    //    task = "<null>";
    //    tid = "<null>";
}

@objc(TimeEntry)
public class TimeEntry: NSManagedObject, TimeEntryLike {
    
    static let entityName = "TimeEntry"
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(from raw: RawTimeEntry, context: NSManagedObjectContext, projects: [Project], tags: [Tag]) {
        super.init(entity: TimeEntry.entity(), insertInto: context)
        update(from: raw, projects: projects, tags: tags)
    }
    
    /// copy properties from raw time entry into TimeEntry
    func update(from raw: RawTimeEntry, projects: [Project], tags: [Tag]) {
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
    
    /// Headlining description,
    /// or project if there's no description,
    /// or placeholder if no info whatsoever
    func descriptionString() -> String {
        if wrappedDescription == "" && ProjectPresets.shared.NoProject == wrappedProject {
            return "No Description"
        } else if wrappedDescription == "" {
            return wrappedProject.name
        } else {
            return wrappedDescription
        }
    }
    
    public override func willSave() {
        if self.project?.id == ProjectPresets.shared.AnyProject.id {
            fatalError("tried to save with project `NoProject`!")
        }
        
        if self.project?.id == ProjectPresets.shared.NoProject.id {
            fatalError("tried to save with project `NoProject`!")
        }
        
        if self.project?.id == ProjectPresets.shared.UnknownProject.id {
            fatalError("tried to save with project `NoProject`!")
        }
    }
}
