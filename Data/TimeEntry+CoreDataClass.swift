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
    var description: String
    
    var start: Date
    var end: Date
    var dur: Double
    var updated: Date
    
    var id: Int
    var is_billable: Bool
    
    var pid: Int?
    var project: String?
    var project_hex_color: String?
    
    var uid: Int; // user ID
    var use_stop: Bool
    var user: String
    //    tags =     ();
    //    task = "<null>";
    //    tid = "<null>";
}

@objc(TimeEntry)
public class TimeEntry: NSManagedObject {
    static let entityName = "TimeEntry"
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(from raw: RawTimeEntry, context: NSManagedObjectContext, projects: [Project]) {
        super.init(entity: TimeEntry.entity(), insertInto: context)
        update(from: raw, context: context, projects: projects)
    }
    
    /// copy properties from raw time entry into TimeEntry
    func update(from raw: RawTimeEntry, context: NSManagedObjectContext, projects: [Project]) {
        self.setValuesForKeys([
            "name": raw.description,
            "start": raw.start,
            "end": raw.end,
            "dur": raw.dur / 1000.0,
            "lastUpdated": raw.updated,
            "id": Int64(raw.id)
        ])
        project = projects.first(where: {$0.id == raw.pid ?? NSNotFound})
    }
    
    /// Headlining description,
    /// or project if there's no description,
    /// or placeholder if no info whatsoever
    func descriptionString() -> String {
        if wrappedDescription == "" && StaticProject.noProject == wrappedProject {
            return "No Description"
        } else if wrappedDescription == "" {
            return wrappedProject.name
        } else {
            return wrappedDescription
        }
    }
}
