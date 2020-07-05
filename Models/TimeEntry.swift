//
//  TimeEntry.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.04.19.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


final class TimeEntry : ObservableObject, Equatable {
    let id:Int
    
    // time parameters
    /// normalized length, from 0 at the center of the spiral, to 1 at the end
    @Published var spiralStart:CGFloat = 0
    @Published var spiralEnd:CGFloat = 0
    
    @Published var rotate = Angle()
    let start: Date // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    let end: Date   // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    let dur: TimeInterval

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
            let end = df.date(from: endString),
            let dur = data["dur"] as? Int
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
        self.end = end
        self.dur = TimeInterval(exactly: dur/1000)!
    }
    
//    // empty initializer for convenience
//    init () {
//        self.project = .noProject
//        self.tid = nil
//        self.task = nil
//        self.description = ""
//        self.start = Date()
//        self.end = Date()
//        self.id = -1
//        self.dur = -1
//    }
    
    // sets the start and end angles based on the provided start datetime
    // similar to "zeroing" a graph or weighing scale
    // NOTE: max angle does not need to be set, capped by ZESpiral
    let radPerSec: Double = (2 * Double.pi) / dayLength
    func zero (_ zeroDate:Date) {
        let startInt = (start > zeroDate) ? (start - zeroDate) : TimeInterval(exactly: 0)
        let endInt = (end > zeroDate) ? (end - zeroDate) : TimeInterval(exactly: 0)
        withAnimation(.spring()) {

            self.spiralStart = archimedianSpiralLength(startInt! * radPerSec) / weekSpiralLength
            self.spiralEnd = archimedianSpiralLength(endInt! * radPerSec) / weekSpiralLength
            
            self.rotate = zeroDate.unboundedClockAngle24()
        }
    }
    
    static func == (lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        /// we could check everything, but unless the data is corrupted we really only need to check task ID
        /// NOTE: if in future we support editing of time entries, this check will need to be more rigorous
        return
            lhs.id == rhs.id &&
            lhs.start == rhs.start &&
            lhs.end == rhs.end &&
            lhs.tid == rhs.tid
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
