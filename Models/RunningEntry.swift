//
//  RunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct RunningEntry {
    let id:Int
    
    let start: Date // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    
    // categorization parameters
    let project: Project
    let tid: Int?
    let task: String?
    let description: String // not nullable
    
    // used to create a TimeEntry from data parsed from JSON
    init?(
        _ data:Dictionary<String,AnyObject>
    ){
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
            let end = df.date(from: endString)
        else { return nil }
        // sanity check, make sure end time is after start time
        guard start < end else { return nil }
        
        self.id = id
        if let name = project, let id = pid {
            self.project = Project(
                name: name,
                color: Color(hex: project_hex_color!),
                id: id
            )
        } else {
            self.project = .noProject
        }
        self.tid = tid
        self.task = task
        self.description = description
        self.start = start
    }
    
    /// Headlining description,
    /// or project if there's no description,
    /// or placeholder if no info whatsoever
    func descriptionString() -> String {
        if description == "" && project == .noProject {
            return "No Description"
        } else if description == "" {
            return project.name
        } else {
            return description
        }
    }

}
