//
//  Period.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
// Represents the time entries over a period of time, and provides some
// useful information about that period

import Foundation

struct Period {
    
    var start:Date
    var end:Date
    var entries:[TimeEntry]
    
    // represents whether you want to know about the beginning or end of a set of time entries
    enum cap {
        case start
        case end
    }
    let day = TimeInterval(exactly: 24 * 60 * 60)!
    
    
    init(start:Date, end:Date, entries:[TimeEntry]) {
        self.start = start
        self.end = end
        // include entries which are only partially inside the period
        self.entries = entries
            .filter() {$0.start < end}
            .filter() {$0.end > start}
    }
    
    // returns the usual start / end times of a specified project
    // each day over the time period
    // takes the earliest start of the earliest activity, instead of counting 2 entries in 1 day separately
//    func meanCap(project:String, cap: cap) -> Date {
//        let projectEntries = self.entries.filter() {$0.project == project}
//        let selected = [Date]()
//        for start in stride(from: start, to: end, by: day) {
//            
//        }
//    }
    
    // returns the total amount of time logged over the period
    // for entries matching the criterion (nil to match all)
    func totalTime(project:String?, description:String?) -> TimeInterval {
        var total:TimeInterval = 0
        self.entries.forEach() { entry in
            if project != nil && entry.project != project {
                return
            }
            if description != nil && entry.description != description {
                return
            }
            // cap the start and end at the time period's start and end
            total += min(entry.end, end) - max(entry.start, start)
        }
        return total
    }
}
