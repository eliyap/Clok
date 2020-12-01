//
//  EntryList.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct ListView: View {
    
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var model: NewGraphModel
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) private var entries: FetchedResults<TimeEntry>

    let start: Date
    let animationInfo: (namespace: Namespace.ID, row: Int)
    
    var body: some View {
        VStack {
            ForEach(entries(midnight: start), id: \.id) { entry in
                DetailView(entry: entry)
            }
        }
    }
    
    /// filter & sort time entries for this day
    /// the day begins at provided `midnight`
    func entries(midnight: Date) -> [TimeEntry] {
        entries
            /// **NOTE**: this filter EXCLUDES entries that started before midnight, to prevent `matchedGeometryEffect` duplicates
            .filter{$0.start > midnight}
            .filter{$0.start < midnight + .day}
            /// chronological sort
            .sorted{$0.start < $1.start}
    }
    
    func DetailView(entry: TimeEntry) -> some View {
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
            .background(entry.color)
            .matchedGeometryEffect(id:
                NamespaceModel(
                    entry: entry,
                    row: animationInfo.row,
                    col: start.timeIntervalSince1970
                ),
               in: animationInfo.namespace
            )
    }
}
