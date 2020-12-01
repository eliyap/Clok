//
//  DayCalendarBody.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension NewGraph {
    func DayCalendarBody(size: CGSize, idx: Int) -> some View {
        let start = Date().midnight.advanced(by: Double(idx) * .day)
        return HStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            NewDayStrip(
                entries: entries
                    .filter{$0.end > start}
                    .filter{$0.start < start + .day}
                    /// chronological sort
                    .sorted{$0.start < $1.start},
                midnight: start,
                terms: data.terms,
                animationInfo: (row: idx, start.timeIntervalSince1970)
            )
                .frame(height: size.height)
                /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
                .background(NewLinedBackground(divisions: evenDivisions(for: size.height)))
                .drawingGroup()
        }
        .padding(.top, -NewGraph.footerHeight)
    }
}
