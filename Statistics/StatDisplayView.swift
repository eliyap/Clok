//
//  StatDisplayView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct StatDisplayView: View {
    
    var week: WeekTimeFrame
    
    private let df = DateFormatter()
    private var avgStart = ""
    private var avgEnd = ""
    private var avgDur: TimeInterval = 0
    
    
    var body: some View {
        Group {
            Stat(
                label: "Started Around",
                symbol: "sun.dust.fill",
                text: Text(avgStart)
            )
            Stat(
                label: "Ended Around",
                symbol: "moon.stars.fill",
                text: Text(avgEnd)
            )
            Stat(
                label: "Hours Logged",
                symbol: "hourglass.tophalf.fill",
                text: Text(avgDur.toString())
            )
        }
    }
    
    init(for week_: WeekTimeFrame) {
        df.timeStyle = .short
        df.dateStyle = .none
        
        week = week_
        
        /// handle cases where there are no entries
        if let start = week.avgStartTime() {
            avgStart = df.string(from: start)
        } else {
            avgStart = "--:--"
        }
        
        if let end = week.avgEndTime() {
            avgEnd = df.string(from: end)
        } else {
            avgEnd = "--:--"
        }
        
        avgDur   = week.avgDuration()
    }
}
