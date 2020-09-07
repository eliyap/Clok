//
//  Piece7.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static let _7 = ConfigurablePiece(
        value: 7,
        pieces: TetrisPiece([
            [true, true, true, true, true],
            [true, true, false, false, false],
        ]).mirroredRotations
        + TetrisPiece([
                [true, true, true, true],
                [true, true, true, false]
        ]).mirroredRotations
    )
}
