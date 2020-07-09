//
//  Bounds.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func GetBounds(zero: ZeroDate, entry: TimeEntry) -> [LineBar.Bound] {
    var bounds = [LineBar.Bound]()
    for i in 0..<LineGraph.dayCount {
        let begin = zero.date + (Double(i) * dayLength)
        guard entry.end > begin && entry.start < begin + zero.interval else { continue }
        bounds.append(LineBar.Bound(
            max(0, (entry.start - begin) / zero.interval),
            min(1, (entry.end - begin) / zero.interval),
            col: i
        ))
    }
    return bounds
}
