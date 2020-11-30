//
//  EntryView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryView: View {
    private let df = DateFormatter()
    private let radius = CGFloat(10)
    
    var entry: TimeEntry
    let listPadding: CGFloat
    
    let columns = [GridItem(.adaptive(minimum: 10))]
    
    init(entry: TimeEntry, listPadding: CGFloat) {
        self.entry = entry
        self.listPadding = listPadding
        df.timeStyle = .short
    }
    
    var body: some View {
        HStack {
            EntryTab(cornerRadius: radius)
                .foregroundColor(entry.wrappedColor)
                .frame(width: 7)
            VStack {
                HStack {
                    Text(entry.descriptionString())
                        .font(.title3)
                    Spacer()
                    Text(entry.dur.toString())
                        .font(.title3)
                }
                HStack {
                    Text(entry.wrappedProject.name)
                        .font(.caption)
                    Spacer()
                    Text("\(df.string(from: entry.start)) – \(df.string(from: entry.end))")
                        .font(.caption)
                }
                if entry.tagArray.count > 0 {
                    Tags
                }
            }
            .padding(listPadding)
        }
        .background(
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(.background)
        )
        .padding([.leading, .trailing, .bottom], listPadding)
    }
    
    var Tags: some View {
        HStack {
            Image(systemName: "tag")
                .font(.caption)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(entry.sortedTags, id: \.id) {
                        Text($0.name)
                            .lineLimit(1)
                            .font(.caption)
                            .padding(3)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clokBG))
                    }
                }
            }
        }
    }
}

