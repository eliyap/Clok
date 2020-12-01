//
//  DayCalendar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct DayCalendar: View {
    
    @EnvironmentObject var data: TimeData
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>
    
    let dayHeight: CGFloat     /// visual height for 1 day
    let start: Date
    let row: Int
    
    var body: some View {
        NewDayStrip(
            entries: timeEntries,
            midnight: start,
            terms: data.terms,
            animationInfo: (row, start.timeIntervalSince1970)
        )
            .frame(height: dayHeight)
            /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
            .background(NewLinedBackground(divisions: evenDivisions(for: dayHeight)))
            .drawingGroup()
    }
    
    var timeEntries: [TimeEntry] {
        entries
            .filter{$0.end > start}
            .filter{$0.start < start + .day}
            /// chronological sort
            .sorted{$0.start < $1.start}
    }
}
