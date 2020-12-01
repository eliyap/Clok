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
                Text(entry.entryDescription)
                    .background(entry.color)
                    .matchedGeometryEffect(id:
                        NamespaceModel(
                            entryID: entry.id,
                            row: animationInfo.row,
                            col: start.timeIntervalSince1970
                        ),
                       in: animationInfo.namespace
                    )
            }
        }
    }
    
    /// filter & sort time entries for this day
    /// the day begins at provided `midnight`
    func entries(midnight: Date) -> [TimeEntry] {
        entries
            .filter{$0.end > midnight}
            .filter{$0.start < midnight + .day}
            /// chronological sort
            .sorted{$0.start < $1.start}
    }
}
