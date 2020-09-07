//
//  WidgetView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct GridWidgetEntryView : View {
    var entry: SummaryEntry
    let board: Board? = solve(sizes: [
        (1, .blue),
        (12, .blue),
        (7, .blue),
    ])
    
    var body: some View {
        if let board = board {
            ForEach(0..<board.dimensions.width) { row in
                VStack {
                    ForEach(0..<board.dimensions.height) { col in
                        Circle()
                            .foregroundColor(board.openings[row][col] ?? .clear)
                    }
                }
            }
        } else {
            Text("No soln. rip")
        }
        
    }
}
