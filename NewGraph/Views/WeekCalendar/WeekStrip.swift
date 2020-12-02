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
struct WeekStrip: View {
    
    @EnvironmentObject var bounds: Bounds
    @EnvironmentObject var model: NewGraphModel
    
    let entries: [TimeEntry]
    let midnight: Date
    let terms: SearchTerms
    let animationInfo: (namespace: Namespace.ID, row: Int, col: TimeInterval)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(entries, id: \.id) { entry in
                    WeekRect(
                        entry: entry,
                        size: geo.size,
                        midnight: midnight,
                        animationInfo: animationInfo
                    )
                        /// push `View` down to `(proportion through the day x height)`
                        .offset(y: CGFloat((entry.start - midnight) / .day) * geo.size.height)
                        /// fade out views that do not match the filter
                        .opacity(entry.matches(terms) ? 1 : 0.25)
                        /// push View to stack when tapped
                        .onTapGesture {
                        withAnimation {
                                model.selected = NamespaceModel(
                                    entry: entry,
                                    row: animationInfo.row,
                                    col: animationInfo.col
                                )
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
                    NewRunningEntryView(terms: terms)
                }
            }
        }
    }
}
