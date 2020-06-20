//
//  StatView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct StatView: View {
    var week: WeekTimeFrame
    private let df = DateFormatter()
    private var avgStart = Date()
    private var avgEnd = Date()
    @State private var terms = SearchTerm(
        project: "School",
        description: "",
        byProject: true,
        byDescription: false
    )
    
    var body: some View {
        VStack {
            Text("\(df.string(from: avgStart))")
            Text("\(df.string(from: avgEnd))")
        }
        
    }
    
    init(week week_: WeekTimeFrame) {
        week = week_
        avgStart = week.avgStartTime(for: terms)
        avgEnd   = week.avgEndTime(for: terms)
        df.timeStyle = .short
        df.dateStyle = .short
    }
}
