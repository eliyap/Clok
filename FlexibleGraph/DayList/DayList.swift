//
//  DayList.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    func DayList(idx: Int) -> some View {
        let start = Date().midnight.advanced(by: Double(idx) * .day)
        return VStack {
            /// pushes the first entry clear of the `DateLabel`
            Text(".")
                .bold()
                .foregroundColor(.clear)
            ForEach(
                entries
                    /// **NOTE**: this filter EXCLUDES entries that started before midnight, to prevent `matchedGeometryEffect` duplicates
                    .filter{$0.start > start}
                    .filter{$0.start < start + .day}
                    /// chronological sort
                    .sorted{$0.start < $1.start},
                id: \.id
            ) { entry in
                DetailView(entry: entry, row: idx, col: start.timeIntervalSince1970)
            }
        }
    }
    
    func DetailView(entry: TimeEntry, row: Int, col: Double) -> some View {
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
            .background(entry.color(in: mode))
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
            .matchedGeometryEffect(id:
                NamespaceModel(
                    entry: entry,
                    row: row,
                    col: col
                ),
               in: namespace
            )
    }
}
