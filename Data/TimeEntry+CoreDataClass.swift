//
//  TimeEntry+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import SwiftUI
import CoreData

@objc(TimeEntry)
public class TimeEntry: NSManagedObject {
    
    // parse TimeEntry from JSON
    init?(from data: [String : AnyObject], in context: NSManagedObjectContext){
        super.init(entity: TimeEntry.entity(), insertInto: context)
        
        // initialize DateFormatter to handle ISO8601 strings
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        // nullable properties
        // downcast cannot be checked via "guard"
        let pid = data["pid"] as? Int
        let project = data["project"] as? String
        let project_hex_color = data["project_hex_color"] as? String
        let tid = data["tid"] as? Int
        let task = data["task"] as? String
        
        // check that these properties are not nil
        guard
            let id = data["id"] as? Int,
            data["description"] != nil,
            let description = data["description"] as? String,
            // get Dates from ISO8601 string
            data["start"] != nil,
            let startString = data["start"] as? String,
            let start = df.date(from: startString),
            data["end"] != nil,
            let endString = data["end"] as? String,
            let end = df.date(from: endString),
            let dur = data["dur"] as? Int
        else { return nil }
        // sanity check, make sure end time is after start time
        guard start < end else { return nil }
        
        self.id = Int64(id)
        if let name = project, let id = pid {
            self.project = Project(
                in: context,
                name: name,
                colorHex: project_hex_color!,
                id: id
            )
        } else {
            self.project = .noProject
        }
        self.tid = Int64(tid ?? NSNotFound)
        self.task = task
        self.name = description
        self.start = start
        self.end = end
        
        /// convert milliseconds to seconds
        self.dur = TimeInterval(exactly: dur/1000)!
    }
}
