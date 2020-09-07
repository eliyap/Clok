//
//  Piece11.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static let _11 = ConfigurablePiece(
        value: 11,
        pieces: [
            TetrisPiece([
                [true, true, true, true, true],
                [true, true, true, true, true],
                [true, false, false, false, false]
            ]),
            TetrisPiece([
                [false, false, false, false, true],
                [true, true, true, true, true],
                [true, true, true, true, true]
            ])
            /**
             If 11 was placed second, the first piece will have filled rows 1 & 2, so rotate
             180 degrees, but don't bother mirroring
             If 11 was placed first, rotating / mirroring is the same problem
             */
        ]
    )
}
