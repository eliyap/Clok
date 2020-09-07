//
//  Board.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Board {
    let dimensions: Dimensions
    var openings: [[Color?]]
    
    init(openings: [[Color?]]) {
        self.openings = openings
        dimensions = (
            width: openings[0].count,
            height: openings.count
        )
        
        /// ensure size is valid
        precondition(dimensions.height > 0 && dimensions.width > 0)
        
        /// ensure matrix is not ragged
        for row in openings {
            precondition(row.count == dimensions.width)
        }
    }
    
    static let starting = Board(openings: [
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, .clear, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
    ])
    
    static let placeholder = Board(openings: [
        [.blue, .blue, .blue, .blue, .green],
        [.blue, .blue, .blue, .blue, .green],
        [.purple, .purple, .clear, .orange, .green],
        [.purple, .purple, .gray, .orange, .yellow],
        [.purple, .purple, .gray, .orange, .yellow],
    ])
}
