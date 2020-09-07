//
//  Fill.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/**
 Generate all possible placements of a piece on some board,
 returning the possible new boards
 */
func placements(on board: Board, piece: TetrisPiece, color: Color) -> [Board] {
    /// generate valid positions
    let positions = (0...(board.dimensions.width - piece.dimensions.width)).map { x in
        (0...(board.dimensions.height - piece.dimensions.height)).map { y in
            (x, y)
        }
    }.reduce([], +)
    
    func place(at pos: Position) -> Board? {
        var new_board = board
        for pieceX in 0..<piece.dimensions.width {
            for pieceY in 0..<piece.dimensions.height {
                let boardFilled = new_board.openings[pos.y + pieceY][pos.x + pieceX]
                let pieceFilled = piece.fillings[pieceY][pieceX]
                switch (boardFilled, pieceFilled) {
                /// if piece does not try to fill this space, continue
                case (_, false):
                    break
                
                /// fill empty space with `color`
                case (nil, true):
                    new_board.openings[pos.y + pieceY][pos.x + pieceX] = color
                
                /// collision! return nothing
                case (.some, true):
                    return nil
                }
            }
        }
        return new_board
    }
    
    /// try each position,  returning only successful fills
    return positions.compactMap {
        place(at: $0)
    }
}
