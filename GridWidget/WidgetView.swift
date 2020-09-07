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
    
    let board: Board?
    
    init(entry: BoardEntry){
        self.board = entry.board
    }
    
    var body: some View {
        if let board = board {
            VStack {
                ForEach(0..<board.dimensions.width) { row in
                    HStack {
                        ForEach(0..<board.dimensions.height) { col in
                            Cell(row: row, col: col)
                        }
                    }
                }
            }
            .padding()
        } else {
            Text("No soln. rip")
        }
    }
    
    func Cell(row: Int, col: Int) -> some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: geo.size.height / 4)
                .foregroundColor(board!.openings[row][col] ?? .clear)
        }
//        Circle()
//            .foregroundColor(board!.openings[row][col] ?? .clear)
    }
}
