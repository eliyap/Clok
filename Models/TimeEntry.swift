//
//  TimeEntry.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.04.19.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


class TimeEntry : ObservableObject, Equatable {
    let id:Int
    
    // time parameters
    @Published var startTheta = Angle(degrees: 0)
    @Published var endTheta = Angle(degrees: 0)
    let start: Date // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    let end: Date   // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    let dur: TimeInterval

    // categorization parameters
    let pid: Int?
    let project: String?
    let project_hex_color: Color
    let tid: Int?
    let task: String? // might not be a string???
    let description: String // not nullable
    
    // businessy parameters
    let client: String=""
//    let billable: Bool?
    // let is_billable
    // let cur // currency
    
    // as yet unhandled
    let uid: Int = 0
    let user: String = ""
    // let tags
    
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
        else {
            #if DEBUG
            print("Entry initialization failed!")
            print(data)
            #endif
            return nil
        }
        // sanity check, make sure end time is after start time
        guard start < end else {
            #if DEBUG
            print("Start cannot be after end!")
            print(data)
            #endif
            return nil
        }
        
        self.id = id
        self.pid = pid
        self.project = project
        self.project_hex_color = Color(hex: project_hex_color ?? "#888888") // middle of the road grey, replace with dark mode sensitive color later
        self.tid = tid
        self.task = task
        self.description = description
        self.start = start
        self.end = end
        self.dur = TimeInterval(exactly: dur/1000)!
    }
    
    // empty initializer for convenience
    init () {
        self.pid = nil
        self.project = nil
        self.project_hex_color = Color.black
        self.tid = nil
        self.task = nil
        self.description = ""
        self.start = Date()
        self.end = Date()
        self.id = -1
        self.dur = -1
    }
    
    // sets the start and end angles based on the provided start datetime
    // similar to "zeroing" a graph or weighing scale
    // NOTE: max angle does not need to be set, capped by ZESpiral
    let degreesPerSec: Double = 360.0 / dayLength
    func zero (_ zeroDate:Date) {
        let startInt = (start > zeroDate) ? (start - zeroDate) : TimeInterval(exactly: 0)
        let endInt = (end > zeroDate) ? (end - zeroDate) : TimeInterval(exactly: 0)
        withAnimation(.easeInOut(duration: 0.5)) {
            self.startTheta = Angle(degrees: startInt! * degreesPerSec)
            self.endTheta = Angle(degrees: endInt! * degreesPerSec)
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
}
