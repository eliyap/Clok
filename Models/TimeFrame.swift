//
//  TimeFrame.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.23.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
import simd

protocol TimePeriod {
    var start:Date {get}
    var end:Date {get}
    var length:TimeInterval {get}
}

struct WeekTimeFrame : TimePeriod {
    var start:Date
    var end:Date
    let length = weekLength
    
    enum contains {
        case doesNot
        case partially
        case completely
    }
    
    init(starts:Date) {
        self.start = starts
        assert(
            Calendar.current.component(.hour, from:starts) == 0 &&
            Calendar.current.component(.minute, from:starts) == 0,
            "Week must start at midnight!"
        )
        self.end = starts.addingTimeInterval(weekLength)
    }
    
    // check whether a given TimePeriod falls within this TimeFrame
    func contains(_ entry:TimeEntry) -> contains {
        if entry.start > self.end { return .doesNot }
        if entry.end < self.start { return .doesNot }
        if entry.start < self.start { return .partially }
        if entry.end > self.end { return .partially }
        assert(self.start < entry.start && self.end > entry.end, "Logical error in contains comparison!")
        return .completely
    }
    
    // returns the Angles for this TimeEntry
    func getAngles(_ entry:TimeEntry) -> (Angle, Angle) {
        (
            Angle(radians: ((entry.start - self.start) / weekLength) * 14 * Double.pi),
            Angle(radians: ((entry.end - self.start) / weekLength) * 14 * Double.pi)
        )
    }
    
    // the start and end positions on the week spiral of the given time entry
    func phase(_ date:Date) -> Double {
        // normalized Time in range [0, 1]
        let nT = (date - self.start) / weekLength
        // get angle on the spiral
        let a = nT * 14 * Double.pi
        return (a * sqrt(a * a + 1) + asinh(a)) / 2
    }
    
    
}
