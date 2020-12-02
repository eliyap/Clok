//
//  WeekCalendar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct WeekCalendar: View {
    
    @EnvironmentObject var data: TimeData
    @Environment(\.namespace) var namespace
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>

    let dayHeight: CGFloat     /// visual height for 1 day
    let start: Date
    let row: Int
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly coincide
        HStack(spacing: .zero) {
            /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
            ForEach(
                Array(stride(from: start, to: start + .week, by: .day)),
                id: \.timeIntervalSince1970
            ) { midnight in
                Divider()
                WeekStrip(
                    /// filter & sort time entries for this day
                    /// the day begins at provided `midnight`
                    entries: entries
                        .filter{$0.end > midnight}
                        .filter{$0.start < midnight + .day}
                        /// chronological sort
                        .sorted{$0.start < $1.start},
                    midnight: midnight,
                    terms: data.terms,
                    animationInfo: (
                        namespace,
                        row,
                        midnight.timeIntervalSince1970
                    )
                )
                    .frame(height: dayHeight)
            }
        }
            /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
            .background(NewLinedBackground(divisions: evenDivisions(for: dayHeight)))
            .drawingGroup()
    }
}
