//
//  Piece8.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static let _8 = ConfigurablePiece(
        value: 8,
        pieces: [
            TetrisPiece([
                [true, true, true, true],
                [true, true, true, true]
            ]),
            TetrisPiece([
                [true, true, true],
                [true, false, true],
                [true, true, true]
            ]),
            TetrisPiece([
                [true, true],
                [true, true],
                [true, true],
                [true, true]
            ])
        ] + TetrisPiece([
            [true, true, true, true, true],
            [true, true, true, false, false],
        ]).mirroredRotations
    )
}
