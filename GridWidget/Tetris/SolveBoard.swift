//
//  SolveBoard.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

func solve(sizes: [(Int, Color)]) -> Board? {
    /// ensure sum is less than 24, otherwise immediately abandon
    guard sizes.reduce(0, {$0 + $1.0}) < 24 else {
        return nil
    }
    
    /// generate colored pieces
    let cPieces: [(ConfigurablePiece, Color)] = sizes.sorted(by: {$0.0 > $1.0}).map {
        (ConfigurablePiece.ofSize($0.0), $0.1)
    }
    
    func addPiece(
        index: Int,
        to board: Board
    ) -> Board? {
        /// if index passes array end, board is solved
        guard index < cPieces.count else {
            return board
        }
        let cPiece = cPieces[index]
        var result: Board? = nil
        /// for each possible piece
        pieceLoop: for tPiece in cPiece.0.pieces {
            /// on each possible board
            for new_board in placements(on: board, piece: tPiece, color: cPiece.1) {
                /// try to add the next piece
                result = addPiece(
                    /// try to add the next piece
                    index: index + 1,
                    to: new_board
                )
                /// break if a solution was found
                guard result == nil else {
                    break pieceLoop
                }
            }
        }
        /// all attempts failed
        return result
    }
    return addPiece(index: 0, to: .starting)
}
