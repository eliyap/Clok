//
//  Piece10.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static let _10 = ConfigurablePiece(
        value: 10,
        pieces: [
            TetrisPiece([
                [true, true, true, true, true],
                [true, true, true, true, true]
            ])
            /**
             If 10 was placed second, the first piece will have filled rows 1 & 2, so don't bother
             If 10 was placed first, rotating it only rotates the same problem
             */
//            TetrisPiece([
//                [true, true],
//                [true, true],
//                [true, true],
//                [true, true],
//                [true, true]
//            ])
        ]
    )
}
