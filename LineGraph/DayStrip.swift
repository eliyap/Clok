//
//  DayStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let labelOffset = CGFloat(-10)
fileprivate let labelPadding = CGFloat(3)

/// One vertical strip of bars representing 1 day in the larger graph
struct DayStrip: View {
    
    @EnvironmentObject var bounds: Bounds
    @EnvironmentObject var model: GraphModel
    let entries: [TimeEntry]
    let midnight: Date
    let terms: SearchTerms
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                VStack(alignment: .center, spacing: .zero) {
                    ForEach(entries, id: \.id) {
                        EntryRect(
                            range: ($0.start, $0.end),
                            size: geo.size,
                            midnight: midnight,
                            castFwrd: model.castFwrd,
                            castBack: model.castBack,
                            days: model.days
                        )
                        .padding(.top, padding(for: $0, size: geo.size))
                        .foregroundColor($0.wrappedColor)
                        .opacity($0.matches(terms) ? 1 : 0.5)
                    }
                }
                .frame(width: geo.size.width)
                .drawingGroup()
                
                /// show current time in `calendar` mode
                if midnight == Date().midnight && model.mode == .calendar {
                    CurrentTimeIndicator(height: geo.size.height)
                    RunningEntryView(terms: terms)
                }
            }
        }
    }
    
    /// calculate appropriate distance to next `entry`
    func padding(for entry: TimeEntry, size: CGSize) -> CGFloat {
        let scale = size.height / CGFloat(.day * model.days)
        
        let idx = entries.firstIndex(of: entry)!
        guard entry != entries.first else {
            switch model.mode {
            /// if `entry` is cut off by the top of the graph, make it flush with the top, otherwise apply appropriate padding
            case .calendar:
                return entry.start < midnight - model.castBack
                    ? .zero
                    : CGFloat(entry.start - (midnight - model.castBack)) * scale
            /// push the bar graph down to the bottom of the screen
            case .graph:
                let begin = midnight - model.castBack
                let end = midnight + model.castFwrd
                /// deduct all time today from 24 hours
                return CGFloat(entries.reduce(.day, {$0 - (min($1.end, end) - max(begin, $1.start))})) * scale
            }
        }
        
        /// `entry` is not the first entry
        switch model.mode {
        case .calendar:
            return CGFloat(entries[idx].start - entries[idx - 1].end) * scale
        /// no spacing neccessary
        case .graph:
            return .zero
        }
    }
}
