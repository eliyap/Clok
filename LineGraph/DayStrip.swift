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
    let dayCount: Int
    let dfDay = DateFormatter()
    let dfMonth = DateFormatter()
    
    init(
        entries: [TimeEntry],
        begin: Date,
        terms: SearchTerm,
        dayCount: Int
    ){
        self.entries = entries
        self.begin = begin
        self.terms = terms
        self.dayCount = dayCount
        dfDay.setLocalizedDateFormatFromTemplate("dd")
        dfMonth.setLocalizedDateFormatFromTemplate("MMM")
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                HeaderLabel
                    .offset(y: bounds.insets.top - geo.frame(in: .global).minY)
                    .zIndex(1) /// ensure this is drawn first, but remains on top
                ForEach(entries, id: \.id) { entry in
                    LineBar(
                        entry: entry,
                        begin: begin,
                        size: geo.size
                    )
                        .opacity(entry.matches(terms) ? 1 : 0.5)
                }
                
            }
        }
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
        /// add 1 day to compensate for the day strip covering 3 days
        let date = date + dayLength
        if Calendar.current.component(.day, from: date) == 1 {
            return Text(dfMonth.string(from: date)).bold()
        } else {
            return Text(dfDay.string(from: date))
        }
    }
}
