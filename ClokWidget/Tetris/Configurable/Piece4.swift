//
//  Piece4.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static let _4 = ConfigurablePiece(
        value: 4,
        pieces: [
            TetrisPiece([
                [true, true],
                [true, true]
            ]),
            TetrisPiece([
                [true, true, true, true]
            ]),
            TetrisPiece([
                [true],
                [true],
                [true],
                [true]
            ])
            /// more
        ]
    )
}
