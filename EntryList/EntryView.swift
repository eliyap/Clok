//
//  EntryView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryView: View {
    var entry: OldTimeEntry
    private let df = DateFormatter()
    private let radius = CGFloat(10)
    init(entry: OldTimeEntry) {
        self.entry = entry
        df.timeStyle = .short
    }
    
    var body: some View {
        HStack {
            EntryTab(cornerRadius: radius)
                .foregroundColor(entry.project.color)
                .frame(width: listPadding * 1.5)
            VStack {
                HStack {
                    Text(entry.descriptionString())
                        .font(.title3)
                    Spacer()
                    Text(entry.dur.toString())
                        .font(.title3)
                }
                HStack {
                    Text(entry.project.name)
                        .font(.caption)
                    Spacer()
                    Text("\(df.string(from: entry.start)) – \(df.string(from: entry.end))")
                        .font(.caption)
                }
            }
            .padding(listPadding)
        }
        .background(
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(Color(UIColor.systemBackground))
        )
        .padding([.leading, .trailing, .bottom], listPadding)
    }
}

