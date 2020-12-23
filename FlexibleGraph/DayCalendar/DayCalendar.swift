//
//  DayCalendar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    func DayCalendar(size: CGSize, idx: Int) -> some View {
        HStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            DayStack(size: size, idx: idx)
        }
    }
    
    func DayStack(size: CGSize, idx: Int) -> some View {
        let start = Date().midnight.advanced(by: Double(idx) * .day)
        
        return ZStack {
            ForEach(entries
                /// entries where any part falls within this 24 hour day
                .filter{$0.end > start}
                .filter{$0.start < start + .day}
                /// chronological sort
                .sorted{$0.start < $1.start}, id: \.id
            ) { entry in
                DayRect(
                    entry: entry,
                    size: size,
                    midnight: start,
                    idx: idx
                )
                    /// push `View` down to `(proportion through the day x height)`
                    .offset(y: CGFloat((entry.start - start) / .day) * size.height)
                    /// fade out views that do not match the filter
                    .opacity(entry.matches(data.terms) ? 1 : 0.25)
                    /// push View to stack when tapped
                    .onTapGesture { showModal(for: entry, at: idx) }
            }
                .layoutPriority(1)
                .frame(maxWidth: size.width, minHeight: size.height, alignment: .top)

            
            /// show current time in `calendar` mode
            if start == Date().midnight {
                NewCurrentTimeIndicator(height: size.height)
                    .frame(
                        maxWidth: size.width,
                        minHeight: size.height,
                        alignment: .top
                    )
            }
        }
            .frame(height: size.height)
            .background(NewLinedBackground(divisions: evenDivisions(for: size.height)))
            .drawingGroup()
    }
    
    func DayRunning(size: CGSize, start: Date, idx: Int) -> some View {
        let running = WidgetManager.running
        return Group {
            if (running.start - start).isBetween(0, .day) {
                #warning("in development")
                /// temporary placement fix while we integrate `TimeEntryLike` into everything
                Color.clear
                    .frame(maxWidth: size.width, minHeight: size.height, alignment: .top)
                    .overlay(
                        DayRect(entry: running, size: size, midnight: start, idx: idx)
                            .offset(y: CGFloat((running.start - start) / .day) * size.height),
                        alignment: .top
                    )
            } else {
                EmptyView()
            }
        }
    }
}
