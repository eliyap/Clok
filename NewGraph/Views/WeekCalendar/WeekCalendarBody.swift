//
//  WeekCalendarBody.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension NewGraph {
    func WeekCalendarBody(size: CGSize, idx: Int) -> some View {
        
        let start = Date().midnight.advanced(by: Double(idx) * .day)
        
        return HStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(.background)
                .frame(width: size.width, height: size.height)
            
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            
            HStack(spacing: .zero) {
                /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
                ForEach(
                    Array(stride(from: start, to: start + .week, by: .day)),
                    id: \.timeIntervalSince1970
                ) { midnight in
                    Divider()
                    WeekStrip(midnight: midnight, row: idx, col: midnight.timeIntervalSince1970)
                        .frame(height: size.height)
                }
            }
                /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
                .background(NewLinedBackground(divisions: evenDivisions(for: size.height)))
                .drawingGroup()
            
            Rectangle()
                .foregroundColor(.background)
                .frame(width: size.width, height: size.height)
        }
            .frame(width: 3 * size.width)
            .padding(.top, -NewGraph.footerHeight)
            .offset(x: size.width)
    }
    
    // MARK:- WeekStrip
    func WeekStrip(midnight: Date, row: Int, col: Double) -> some View {
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
                        animationInfo: (namespace, row, col)
                    )
                        /// push `View` down to `(proportion through the day x height)`
                        .offset(y: CGFloat((entry.start - midnight) / .day) * geo.size.height)
                        /// fade out views that do not match the filter
                        .opacity(entry.matches(data.terms) ? 1 : 0.25)
                        /// push View to stack when tapped
                        .onTapGesture {
                            withAnimation {
                                model.selected = NamespaceModel(
                                    entry: entry,
                                    row: row,
                                    col: col
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
                    NewRunningEntryView(terms: data.terms)
                }
            }
        }
    }
}
