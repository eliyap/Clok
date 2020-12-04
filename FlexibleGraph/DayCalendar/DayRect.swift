//
//  DayRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    func DayRect(
        entry: TimeEntry,
        size: CGSize,
        midnight: Date,
        border: Bool = false,
        animationInfo: (row: Int, col: TimeInterval)
    ) -> some View {
        let height = size.height * CGFloat((entry.end - entry.start) / .day)
        return entry.color(in: mode)
            /// note: 1/80 is an arbitrary ratio, adjust to taste
            .cornerRadius(min(size.width / 80.0, height / 2))
            .overlay(EntryDetails(entry: entry), alignment: .top)
            .clipped()
            /// note: 0.8 is an arbitrary ratio, adjust to taste
            .matchedGeometryEffect(
                id: NamespaceModel(
                    entry: entry,
                    row: animationInfo.row,
                    col: animationInfo.col
                ),
                in: namespace,
                isSource: !showEntry
            )
            .frame(width: size.width * 0.8, height: height)
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
