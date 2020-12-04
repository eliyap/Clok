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
    
    func DayRect(
        entry: TimeEntry,
        size: CGSize,
        midnight: Date,
        border: Bool = false,
        animationInfo: (namespace: Namespace.ID, row: Int, col: TimeInterval)
    ) -> some View {
        let height = size.height * CGFloat((entry.end - entry.start) / .day)
        return entry.color(in: mode)
            /// note: 1/80 is an arbitrary ratio, adjust to taste
            .cornerRadius(min(size.width / 80.0, height / 2))
            .overlay(EntryDetails(entry: entry), alignment: .top)
            .clipped()
            /// note: 0.8 is an arbitrary ratio, adjust to taste
            .frame(width: size.width * 0.8, height: height)
            .matchedGeometryEffect(
                id: NamespaceModel(
                    entry: entry,
                    row: animationInfo.row,
                    col: animationInfo.col
                ),
                in: animationInfo.namespace,
                isSource: !showEntry
            )
    }
    
    func EntryDetails(entry: TimeEntry) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(entry.entryDescription)
                    .lineLimit(1)
                Spacer()
                Text(entry.projectName)
                    .lineLimit(1)
            }
            Spacer()
            if type(of: entry) == TimeEntry.self {
                Text((entry.end - entry.start).toString())
            }
        }
            .padding(3)
    }
}
