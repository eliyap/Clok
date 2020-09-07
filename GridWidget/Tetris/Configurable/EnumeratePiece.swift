//
//  RotatePiece.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TetrisPiece {
    /**
     the same piece, rotated 90 degrees clockwise
     */
    var rotated: TetrisPiece {
        var new_fillings = Array(
            repeating: Array(
                repeating: false,
                count: dimensions.height
            ),
            count: dimensions.width
        )
        (0..<dimensions.height).forEach { row in
            (0..<dimensions.width).forEach { col in
                new_fillings[col][dimensions.height - 1 - row] = fillings[row][col]
            }
        }
        return TetrisPiece(new_fillings)
    }
    
    var transposed: TetrisPiece {
        var new_fillings = Array(
            repeating: Array(
                repeating: false,
                count: dimensions.height
            ),
            count: dimensions.width
        )
        (0..<dimensions.height).forEach { row in
            (0..<dimensions.width).forEach { col in
                new_fillings[col][row] = fillings[row][col]
            }
        }
        return TetrisPiece(new_fillings)
    }
    
    /**
     All 4 possible rotations of this piece
     */
    var rotations: [TetrisPiece] {
        let _1 = self.rotated
        let _2 = _1.rotated
        let _3 = _2.rotated
        return [self, _1, _2, _3]
    }
    
    /**
     All 8 rotations and mirrors of this piece
     */
    var mirroredRotations: [TetrisPiece] {
        self.rotations + self.transposed.rotations
    }
}
