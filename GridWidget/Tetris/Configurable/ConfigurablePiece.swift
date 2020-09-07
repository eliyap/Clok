//
//  ConfigurablePiece.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct ConfigurablePiece {
    /// how many tiles this would full
    let value: Int
    
    /// the possible shapes for this piece
    let pieces: [TetrisPiece]
    
    init(value: Int, pieces: [TetrisPiece]) {
        self.value = value
        self.pieces = pieces
    }
    
    static func ofSize(_ size: Int) -> ConfigurablePiece {
        precondition(size <= 24)
        precondition(size > 0)
        return [
            1: ._1,
            2: ._2,
            3: ._3,
            4: ._4,
            5: ._5,
            6: ._6,
            7: ._7,
            8: ._8,
            9: ._9,
            10: ._10,
            11: ._11,
            12: ._12
        ][size] ?? largePiece(ofSize: size)
    }
}
