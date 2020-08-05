//
//  DayStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// One vertical strip of bars representing 1 day in the larger graph
struct DayStrip: View {
    
    let entries: [TimeEntry]
    let begin: Date
    let terms: SearchTerm
    let dayCount: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(entries, id: \.id) { entry in
                    LineBar(
                        entry: entry,
                        begin: begin,
                        size: geo.size
                    )
                        .opacity(entry.matches(terms) ? 1 : 0.5)
                }
            }
        }
        
//        .drawingGroup()
    }
}