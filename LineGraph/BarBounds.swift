//
//  Bounds.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// figure out how to draw the bar for this time entry in this time interval
func GetBounds(
    begin: Date, /// beginning of the time interval to consider
    entry: TimeEntry, /// time entry to consider
    interval: TimeInterval /// length of time interval
) -> LineBar.Bound? {
    guard entry.end > begin && entry.start < begin + interval else { return nil }
    return LineBar.Bound(
        max(0, (entry.start - begin) / interval),
        min(1, (entry.end - begin) / interval)
    )
    
}
