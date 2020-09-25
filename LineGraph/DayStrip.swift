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
            ZStack() {
                ForEach(entries, id: \.id) {
                    EntryRect(
                        range: ($0.start, $0.end),
                        size: geo.size,
                        midnight: midnight
                    )
                    .offset(y: padding(for: $0, size: geo.size))
                    .foregroundColor($0.wrappedColor)
                    .opacity($0.matches(terms) ? 1 : 0.25)
                }
                .frame(
                    width: geo.size.width,
                    height: geo.size.height,
                    alignment: model.mode == .calendar ? .top : .bottom
                )
                
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
        
        switch model.mode {
        case .calendar:
            /// how far off the bottom of the graph it should be
            return CGFloat(max(entry.start - (midnight - model.castBack), .zero)) * scale
        case .graph:
            /// find the duration of some time entry within the day
            let clampedDur = { (entry: TimeEntry) -> TimeInterval in
                min(entry.end, midnight + .day) - max(midnight, entry.start)
            }
            
            /// take all entries after this one
            let entriesBelow = entries.suffix(entries.count - 1 - entries.firstIndex(of: entry)!)
            
            /// and sum their clamped durations
            return -CGFloat(entriesBelow.reduce(0, {$0 + clampedDur($1)})) * scale
        }
    }
}
