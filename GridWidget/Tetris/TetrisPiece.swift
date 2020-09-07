//
//  TetrisPiece.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct TetrisPiece {
    let dimensions: Dimensions
    let fillings: [[Bool]]
    
    /**
     `fillings` represents the squares filled by this piece
     determine the width and height.
     */
    init(_ fillings: [[Bool]]){
        self.fillings = fillings
        dimensions = (
            width: fillings[0].count,
            height: fillings.count
        )
        
        /// ensure size is valid
        precondition(dimensions.height > 0 && dimensions.width > 0)
        
        /// ensure matrix is not ragged
        for row in fillings {
            precondition(row.count == dimensions.width)
        }
    }
}
