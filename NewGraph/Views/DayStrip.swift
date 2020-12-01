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
struct NewDayStrip: View {
    
    @EnvironmentObject var bounds: Bounds
    @EnvironmentObject var model: NewGraphModel
    
    let entries: [TimeEntry]
    let midnight: Date
    let terms: SearchTerms
    let namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(entries, id: \.id) { entry in
                    NewEntryRect(
                        entry: entry,
                        size: geo.size,
                        midnight: midnight
                    )
                        .offset(y: padding(for: entry, size: geo.size))
                        .opacity(entry.matches(terms) ? 1 : 0.25)
                        .onTapGesture {
                            model.entry = entry
                        }
                        .matchedGeometryEffect(id: entry.id, in: namespace)
                }
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height,
                        alignment: .top
                    )
                
                /// show current time in `calendar` mode
                if midnight == Date().midnight {
                    NewCurrentTimeIndicator(height: geo.size.height)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .top
                        )
                    NewRunningEntryView(terms: terms)
                }
            }
        }
    }
    
    /// calculate appropriate distance to next `entry`
    func padding(for entry: TimeEntry, size: CGSize) -> CGFloat {
        let scale = size.height / CGFloat(.day)
        return CGFloat(entry.start - midnight) * scale
    }
}
