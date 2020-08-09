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
    let terms: SearchTerm
    let dayHeight: CGFloat
    
    /// determines what proportion of available horizontal space to consume
    private let thicc = CGFloat(0.8)
    private let cornerScale = CGFloat(1.0/18.0)
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                HeaderLabel
                    .offset(y: max(
                        bounds.insets.top - geo.frame(in: .global).minY,
                        .zero
                    ))
                    .zIndex(1) /// ensure this is drawn first, but remains on top
                VStack(spacing: .zero) {
                    ForEach(entries, id: \.id) {
                        RoundedRectangle(cornerRadius: geo.size.width * cornerScale) /// adapt scale to taste
                            .frame(height: height(size: geo.size, entry: $0))
                            .foregroundColor($0.wrappedColor)
                            .padding(.top, padding(for: $0, size: geo.size))
                            .opacity($0.matches(terms) ? 1 : 0.5)
                    }
                }
                .frame(width: geo.size.width * thicc)
            }
            .drawingGroup()
        }
    }
    
    func height(size: CGSize, entry: TimeEntry) -> CGFloat {
        let start = max(entry.start, midnight - model.castBack)
        let end = min(entry.end, midnight + model.castFwrd)
        return size.height * CGFloat((end - start) / (dayLength * model.days))
    }
    
    /// calculate appropriate distance to next time entry
    func padding(for entry: TimeEntry, size: CGSize) -> CGFloat {
        let scale = size.height / CGFloat(dayLength * model.days)
        
        let idx = entries.firstIndex(of: entry)!
        guard entry != entries.first else {
            switch model.mode {
            case .calendar:
                return .zero
            case .graph:
                let begin = midnight - model.castBack
                let end = midnight + model.castFwrd
                /// deduct all time today from 24 hours
                return CGFloat(entries.reduce(dayLength, {$0 - (min($1.end, end) - max(begin, $1.start))})) * scale
            }
        }
        switch model.mode {
        case .calendar:
            return CGFloat(entries[idx].start - entries[idx - 1].end) * scale
        case .graph:
            return .zero
        }
    }
    
    var HeaderLabel: some View {
        /// short weekday and date labels
        VStack(spacing: .zero) {
            Text(midnight.shortWeekday())
                .font(.footnote)
                .lineLimit(1)
            DateLabel(for: midnight)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.clokBG)
    }
    
    func DateLabel(for date: Date) -> Text {
        let df = DateFormatter()
        if Calendar.current.component(.day, from: date) == 1 {
            df.setLocalizedDateFormatFromTemplate("MMM")
            return Text(df.string(from: date)).bold()
        } else {
            df.setLocalizedDateFormatFromTemplate("dd")
            return Text(df.string(from: date))
        }
    }
}
