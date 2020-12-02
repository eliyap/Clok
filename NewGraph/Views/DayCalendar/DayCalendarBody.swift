//
//  DayCalendarBody.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension NewGraph {
    func DayCalendarBody(size: CGSize, idx: Int) -> some View {
        let start = Date().midnight.advanced(by: Double(idx) * .day)
        return HStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
            
            
            ZStack {
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
                        animationInfo: (namespace, idx, start.timeIntervalSince1970)
                    )
                        /// push `View` down to `(proportion through the day x height)`
                        .offset(y: CGFloat((entry.start - start) / .day) * size.height)
                        /// fade out views that do not match the filter
                        .opacity(entry.matches(data.terms) ? 1 : 0.25)
                        /// push View to stack when tapped
                        .onTapGesture {
                            withAnimation {
                                model.selected = NamespaceModel(
                                    entry: entry,
                                    row: idx,
                                    col: start.timeIntervalSince1970
                                )
                            }
                        }
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
                    NewRunningEntryView(terms: data.terms)
                }
            }
        
                .frame(height: size.height)
                .background(NewLinedBackground(divisions: evenDivisions(for: size.height)))
                .drawingGroup()
        }
            .padding(.top, -NewGraph.footerHeight)
    }
}
