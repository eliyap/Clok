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
            
            GeometryReader { geo in
                ZStack {
                    ForEach(entries
                        .filter{$0.end > start}
                        .filter{$0.start < start + .day}
                        /// chronological sort
                        .sorted{$0.start < $1.start}, id: \.id
                    ) { entry in
                        DayRect(
                            entry: entry,
                            size: geo.size,
                            midnight: start
                        )
                            .offset(y: CGFloat((entry.start - start) / .day) * geo.size.height)
                            .opacity(entry.matches(data.terms) ? 1 : 0.25)
                            .onTapGesture {
                                withAnimation {
                                    model.selected = NamespaceModel(
                                        entry: entry,
                                        row: idx,
                                        col: start.timeIntervalSince1970
                                    )
                                }
                            }
                            .matchedGeometryEffect(
                                id: NamespaceModel(
                                    entry: entry,
                                    row: idx,
                                    col: start.timeIntervalSince1970
                                ),
                                in: namespace,
                                anchor: .bottomTrailing
                            )
                    }
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .top
                        )
                    
                    /// show current time in `calendar` mode
                    if start == Date().midnight {
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
                .frame(height: size.height)
                /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
                .background(NewLinedBackground(divisions: evenDivisions(for: size.height)))
                .drawingGroup()
        }
        .padding(.top, -NewGraph.footerHeight)
    }
}
