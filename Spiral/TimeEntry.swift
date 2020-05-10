//
//  TimeEntry.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.04.19.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


struct TimeEntry {
    // time parameters
    let startTheta: Angle
    let endTheta: Angle
    let start: Date // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    let end: Date   // needs to be coerced from ISO 8601 date / time format (YYYY - MM - DDTHH: MM: SS)
    let dur: Int = 0

    // categorization parameters
    let pid: Int?
    let project: String?
    let project_hex_color: String?
    let tid: Int?
    let task: String? // might not be a string???
    let description: String // not nullable
    
    // businessy parameters
    let client: String=""
//    let billable: Bool?
    // let is_billable
    // let cur // currency
    
    // as yet unhandled
    let id: Int = 0//
    let uid: Int = 0
    let user: String = ""
    // let tags
    
    init(
        _ data:Dictionary<String,AnyObject>
    ){
        guard
            // nullable properties
            let pid = data["pid"] as? Int,
            let project = data["project"] as? String,
            let project_hex_color = data["project_hex_color"] as? String,
            let tid = data["tid"] as? Int,
            let task = data["task"] as? String,
            // not nullables
            data["description"] != nil,
            let description = data["description"] as? String,
            // get Dates from ISO8601 string
            data["start"] != nil,
            let startString = data["start"] as? String,
            let start = DateFormatter().date(from: startString),
            data["end"] != nil,
            let endString = data["end"] as? String,
            let end = DateFormatter().date(from: endString)
        else {
            self.pid = nil
            self.project = nil
            self.project_hex_color = nil
            self.tid = nil
            self.task = nil
            self.description = ""
            self.start = Date()
            self.end = Date()
            self.startTheta = Angle(degrees: 0)
            self.endTheta = Angle(degrees: 0)
            return // maybe have a return value indicating failure?
        }
        
        self.pid = pid
        self.project = project
        self.project_hex_color = project_hex_color
        self.tid = tid
        self.task = task
        self.description = description
        self.start = start
        self.end = end
        // calculate start / end angle
        self.startTheta = dateTheta(date: start)
        self.endTheta = dateTheta(date: end)
        
    }
}

let degreesPerMin: Double = 360.0 / (24 * 60)
func dateTheta(date:Date)->Angle{
    var cal = Calendar.current
    let mins = Double(cal.component(.hour, from: date) * 60 + cal.component(.minute, from: date))
    return Angle(degrees: mins * degreesPerMin)
}
