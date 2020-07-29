//
//  Bounds.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func GetBounds(zeroOffset: Date, entry: TimeEntry, interval: TimeInterval) -> [LineBar.Bound] {
    var bounds = [LineBar.Bound]()
    for i in 0..<LineGraph.dayCount {
        let begin = zeroOffset + (Double(i) * dayLength)
        guard entry.wrappedEnd > begin && entry.wrappedStart < begin + interval else { continue }
        bounds.append(LineBar.Bound(
            max(0, (entry.wrappedStart - begin) / interval),
            min(1, (entry.wrappedEnd - begin) / interval),
            col: i
        ))
    }
    return bounds
}
