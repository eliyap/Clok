//
//  EntryView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryView: View {
    var entry: TimeEntry
    private let df = DateFormatter()
    
    init(entry: TimeEntry) {
        self.entry = entry
        df.timeStyle = .short
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.descriptionString())
                Spacer()
                Text(entry.dur.toString())
            }
            HStack {
                Text(entry.project.name)
                Spacer()
                Text("\(df.string(from: entry.start)) – \(df.string(from: entry.end))")
            }
        }
        .background(offBG())
    }
    
    
}

