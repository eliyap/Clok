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
    let entries: [TimeEntry]
    let begin: Date
    let terms: SearchTerm
    let days: Int
    let mode: BarStack.Mode
    let dayHeight: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                HeaderLabel
                    .offset(y: max(
                        bounds.insets.top - geo.frame(in: .global).minY,
                        mode == .graph ? .zero : dayHeight / 2
                    ))
                    .zIndex(1) /// ensure this is drawn first, but remains on top
                VStack(spacing: .zero) {
                    ForEach(entries, id: \.id) {
                        LineBar(
                            entry: $0,
                            begin: begin,
                            size: geo.size,
                            days: days
                        )
                            .padding(.top, padding(for: $0, size: geo.size))
                            .opacity($0.matches(terms) ? 1 : 0.5)
                    }
                }
            }
        }
    }
    
    /// calculate appropriate distance to next time entry
    func padding(for entry: TimeEntry, size: CGSize) -> CGFloat {
        let scale = size.height / CGFloat(dayLength * Double(days))
        let idx = entries.firstIndex(of: entry)!
        /// for first entry, always hit the bottom
        guard idx != 0 else {
            if mode == .graph {
                let end = begin + dayLength
                /// deduct all time today from 24 hours
                return CGFloat(entries.reduce(dayLength, {$0 - (min($1.end, end) - max(begin, $1.start))})) * scale
            }
            else {
                return .zero
            }
        }
        guard mode != .graph else {
            return .zero
        }
        return CGFloat(entries[idx].start - entries[idx - 1].end) * scale
    }
    
    var HeaderLabel: some View {
        /// short weekday and date labels
        VStack(spacing: .zero) {
            Text((begin + dayLength).shortWeekday())
                .font(.footnote)
                .lineLimit(1)
            DateLabel(for: begin)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.clokBG)
    }
    
    func DateLabel(for date: Date) -> Text {
        let df = DateFormatter()
        /// add 1 day to compensate for the day strip covering 3 days
        let date = date + dayLength
        if Calendar.current.component(.day, from: date) == 1 {
            df.setLocalizedDateFormatFromTemplate("MMM")
            return Text(df.string(from: date)).bold()
        } else {
            df.setLocalizedDateFormatFromTemplate("dd")
            return Text(df.string(from: date))
        }
    }
}
