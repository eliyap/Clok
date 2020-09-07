//
//  PieceLarge.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ConfigurablePiece {
    static func largePiece(ofSize size: Int) -> ConfigurablePiece {
        precondition(size <= 24)
        precondition(size > 12)
        return ConfigurablePiece(
            value: size,
            pieces: [
                TetrisPiece([
                    [true, true, true, true, true],
                    [true, true, true, true, true],
                    [true, true, false, size > 12, size >= 13],
                    [size > 14, size > 15, size > 16, size > 17, size > 18],
                    [size > 19, size > 20, size > 21, size > 22, size > 23]
                ])
            ]
        )
    }
}
