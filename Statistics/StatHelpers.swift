//
//  StatHelpers.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/**
 provided a start and end date, returns 24 hour time frames spanning the 2 dates
 (up to the end date, where a partial day is added)
  */
func daySlices(start:Date, end:Date) -> [DayTimeFrame] {
    guard start < end else { fatalError("Invalid date range!") }
    
    var frames = [DayTimeFrame]()
    var slices = [Date]()
    
    for d in stride(from: start, through: end, by: .day) {
        slices.append(d)
    }
    
    for idx in 0..<(slices.count - 1) {
        frames.append(DayTimeFrame(start: slices[idx], end:slices[idx + 1]))
    }
    
    return frames
}
