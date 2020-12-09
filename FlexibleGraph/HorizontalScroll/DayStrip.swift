//
//  DayStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    // MARK:- DayStrip
    func DayStrip(midnight: Date, idx: Int) -> some View {
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
                        idx: idx
                    )
                        /// push `View` down to `(proportion through the day x height)`
                        .offset(y: CGFloat((entry.start - midnight) / .day) * geo.size.height)
                        /// fade out views that do not match the filter
                        .opacity(entry.matches(data.terms) ? 1 : 0.25)
                        /// push View to stack when tapped
                        .onTapGesture { showModal(for: entry, at: idx) }
                }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                
                /// show current time in `calendar` mode
                if Date().between(midnight, midnight + .day) {
                    #warning("still buggy!")
                    NewCurrentTimeIndicator(height: geo.size.height)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .top
                        )
                        .offset(y: geo.size.height * normalizedOffset)
//                    NewRunningEntryView(terms: data.terms)
                }
            }
        }
    }
    
    /// conditional variable helping to keep the `CurrentTimeIndicator` in the right column
    private var normalizedOffset: CGFloat {
        /// suppose the current time is `x` of the way through a 24 hour day, e.g. 8a.m. is 1/3 of the way,
        /// then the offset should be between `(-1/3, 2/3)`.
        TimeInterval(rowPosition.position.y) * .day < Date() - Date().midnight
            ? 0 - rowPosition.position.y
            : 1 - rowPosition.position.y
    }
}
