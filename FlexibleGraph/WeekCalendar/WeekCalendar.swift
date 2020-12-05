//
//  WeekCalendar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    /// View of a 1 week Calendar
    /// NOTE: this sandwiches the body between 2 off screen rects of equal size,
    /// to facilitate some as yet unimplemented `matchedGeometryEffect` animations
    /// - Parameters:
    ///   - size: page size
    ///   - idx: row number
    /// - Returns: `View` of a 1 week Calendar
    func WeekCalendar(size: CGSize, idx: Int) -> some View {
        HStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(.background)
                .frame(width: size.width, height: size.height)
            WeekCalendarBody(size: size, idx: idx)
                .frame(width: size.width, height: size.height)
            Rectangle()
                .foregroundColor(.background)
                .frame(width: size.width, height: size.height)
        }
            .frame(width: size.width)
            .drawingGroup()
    }
    
    func WeekCalendarBody(size: CGSize, idx: Int) -> some View {
        let start = Date().midnight.advanced(by: Double(idx) * .day)
        /// since above `HStack`s this, just return `Group`
        return HStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
            ForEach(
                Array(stride(from: start, to: start + .week, by: .day)),
                id: \.timeIntervalSince1970
            ) { midnight in
                /// vertical dividing line between each day
                Divider()
                WeekStrip(midnight: midnight, row: idx, col: midnight.timeIntervalSince1970)
                    .frame(height: size.height)
            }
        }
            /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
            .background(NewLinedBackground(divisions: evenDivisions(for: size.height)))
    }
    
    // MARK:- WeekStrip
    func WeekStrip(midnight: Date, row: Int, col: Double) -> some View {
        GeometryReader { geo in
            ZStack {
                ForEach(
                    entries
                        .filter{$0.end > midnight}
                        .filter{$0.start < midnight + .day}
                        /// chronological sort
                        .sorted{$0.start < $1.start}
                    , id: \.id
                ) { entry in
                    WeekRect(
                        entry: entry,
                        size: geo.size,
                        midnight: midnight,
                        animationInfo: (row, col)
                    )
                        /// push `View` down to `(proportion through the day x height)`
                        .offset(y: CGFloat((entry.start - midnight) / .day) * geo.size.height)
                        /// fade out views that do not match the filter
                        .opacity(entry.matches(data.terms) ? 1 : 0.25)
                        /// push View to stack when tapped
                        .onTapGesture {
                            model.geometry = NamespaceModel(entryID: entry.id, row: row, col: col)
                            withAnimation {
                                model.selected = entry
                            }
                        }
                }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
                /// show current time in `calendar` mode
                if midnight == Date().midnight {
                    NewCurrentTimeIndicator(height: geo.size.height)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .top
                        )
//                    NewRunningEntryView(terms: data.terms)
                }
            }
        }
    }
}
