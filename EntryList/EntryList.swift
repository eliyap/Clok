//
//  EntryList.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryList: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var bounds: Bounds
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>
    
    let listPadding: CGFloat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Title
                /// adjust end date to be just before midnight of the last day
                ForEach(Days(), id: \.id) { day in
                    Section(header: Header(day)) {
                        LazyVStack(spacing: 0) {
                            ForEach(day.entries, id: \.id) { entry in
                                EntryView(
                                    entry: entry,
                                    listPadding: listPadding
                                )
                                    .id(entry.id)
                            }
                        }
                    }
                }
                /// fuuuuuuutuuuuure
                if zero.start >= Date().midnight {
                    Text("What does the future hold?")
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    var Title: some View {
        let text = Text("Entries").bold()
        if bounds.device == .iPhone && bounds.mode == .portrait {
            return text
                .font(.title2)
                .padding([.leading, .trailing], listPadding)
        } else {
            return text
                .font(.title)
                .padding([.leading, .trailing], listPadding)
        }
    }
    
    func Header(_ day: Day) -> some View {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM dd")
        
        let cal = Calendar.current
        let currentYear = cal.component(.year, from: Date())
        let zeroYear = cal.component(.year, from: zero.start)
                
        /// day of week, day of month, MMM
        let dateString =  [
            day.start.shortWeekday,
            df.string(from: day.start),
            /// plus optional YYYY if it is not current year
            ((currentYear == zeroYear) ? "" : "\(zeroYear)")
        ].joined(separator: " ")
        
        return VStack(alignment: .leading) {
            Text(dateString)
                .font(Font.title2.weight(.bold))
            Divider()
        }
        .padding([.leading, .trailing], listPadding)
    }
    
    struct Day {
        var id: Int
        var start: Date
        var entries: [TimeEntry]
    }
    
    func Days() -> [Day] {
        /// restrict to current week
        let validEntries = entries
            .sorted(by: {$0.start < $1.start} )
            .within(interval: .week, of: zero.start)
            .matching(terms: data.terms)
        
        var days = [Day]()
        for mn in stride(
            from: zero.start,
            to: zero.end,
            by: .day
        ) {
            days.append(Day(
                id: Int(mn.timeIntervalSince1970),
                start: mn,
                entries: validEntries
                    /// restrict entries to those that started in this 24 hour period
                    /// NOTE: don't use `within`, as this causes some entries to appear across 2 days, causing a crash!
                    .filter{ $0.start.between(mn, mn + .day) }
            ))
        }
        
        return days.filter{ $0.entries.count > 0 }
    }
}
