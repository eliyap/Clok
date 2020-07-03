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
    
    private let df = DateFormatter()
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        List {
            ForEach(Days(), id: \.id) { day in
                Section(header: Text(df.string(from: day.start))) {
                    ForEach(day.entries, id: \.id) { entry in
                        EntryView(entry: entry)
                    }
                }
            }
        }
    }
    
    struct Day {
        var id: Int
        var start: Date
        var entries: [TimeEntry]
    }
    
    func Days() -> [Day] {
        /// restrict to current week
        let entries = data.report.entries.within(interval: weekLength, of: zero.date)
        
        var days = [Day]()
        let cal = Calendar.current
        for mn in stride(
            from: cal.startOfDay(for: zero.date),
            through: cal.startOfDay(for: zero.date + weekLength),
            by: dayLength
        ) {
            days.append(Day(
                id: Int(mn.timeIntervalSince1970),
                start: mn,
                entries: entries.within(interval: dayLength, of: mn)
            ))
        }
        return days
    }
    
    func HeaderFor(section: Day) -> String {
        let cal = Calendar.current
        let currentYear = cal.component(.year, from: Date())
        let zeroYear = cal.component(.year, from: zero.date)
        
        /// day of week, day of month, MMM
        return [
            section.start.shortWeekday(),
            df.string(from: section.start),
            /// plus optional YYYY if it is not current year
            ((currentYear == zeroYear) ? "" : "\(zeroYear)")
        ].joined(separator: " ")
    }
}

struct EntryList_Previews: PreviewProvider {
    static var previews: some View {
        EntryList()
    }
}
