//
//  NewLineGraphView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct NewLineGraphView: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var model: NewGraphModel
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>

    let dayHeight: CGFloat     /// visual height for 1 day
    let start: Date
    
    var duration: TimeInterval {
        switch model.mode {
        case .dayMode:
            return .day
        case .weekMode:
            return .week
        case .listMode: return .day
        }
    }
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly coincide
        HStack(spacing: .zero) {
            /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
            ForEach(
                Array(stride(from: start, to: start + duration, by: .day)),
                id: \.timeIntervalSince1970
            ) { midnight in
                Divider()
                NewDayStrip(
                    entries: entries(midnight: midnight),
                    midnight: midnight,
                    terms: data.terms
                )
                    .frame(height: heightConstraint)
            }
        }
        /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
        .background(NewLinedBackground(divisions: evenDivisions(for: dayHeight)))
        .drawingGroup()
    }
    
    /// filter & sort time entries for this day
    /// the day begins at provided `midnight`
    func entries(midnight: Date) -> [TimeEntry] {
        entries
            .filter{$0.end > midnight}
            .filter{$0.start < midnight + .day}
            /// chronological sort
            .sorted{$0.start < $1.start}
    }
    
    var heightConstraint: CGFloat? {
        switch model.mode {
        case .weekMode, .dayMode:
            return dayHeight
        case .listMode:
            return .none
        }
    }
}
