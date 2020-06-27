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
    private var avgStart = Date()
    private var avgEnd = Date()
    private var avgDur: TimeInterval = 0
    
    
    var body: some View {
        Group {
            Stat(
                label: "Started Around",
                symbol: "sun.dust.fill",
                text: Text(df.string(from: avgStart))
            )
            Stat(
                label: "Ended Around",
                symbol: "moon.stars.fill",
                text: Text(df.string(from: avgEnd))
            )
            Stat(
                label: "Hours Logged",
                symbol: "hourglass.tophalf.fill",
                text: Text(avgDur.toString())
            )
        }
    }
    
    init(for week_: WeekTimeFrame) {
        week = week_
        avgStart = week.avgStartTime()
        avgEnd   = week.avgEndTime()
        avgDur   = week.avgDuration()
        
        df.timeStyle = .short
        df.dateStyle = .none
    }
}
