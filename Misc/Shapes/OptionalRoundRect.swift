//
//  OptionalRoundRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct OptionalRoundRect: Shape {
    
    var bound: LineBar.Bound
    
    func path(in rect: CGRect) -> Path {
        /// place with half the whitespace to center the graph
        let factor: CGFloat = (1.0 - LineBar.thicc) / 2.0
        
        /// calculate the position of the bar
        let pos = CGPoint(
            x: rect.width / CGFloat(LineGraph.dayCount) * factor,
            y: CGFloat(bound.min) * rect.height
        )
        
        return Path { path in
            path.move(to: pos)
            path.addLine(to: CGPoint(
                x: pos.x,
                y: CGFloat(bound.max) * rect.height
            ))
        }
        .strokedPath(StrokeStyle(
            lineWidth: rect.width / CGFloat(LineGraph.dayCount * 3),
            lineCap: .butt
        ))
        .strokedPath(StrokeStyle(
            lineWidth: rect.width / CGFloat(LineGraph.dayCount * 2),
            lineCap: .butt,
            lineJoin: .round
        ))
        
    }
}

