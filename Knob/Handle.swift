//
//  arc.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.07.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
/**
 creates a circular arc shaped handle
 using the double stroke method similar to the entry spiral
 */
struct Handle : Shape {
    // based on a 100 x 100 bounding rect
    private let arcLength = Angle(degrees: 30.0)
    private let thiccness = 10
    private let innerRadius = CGFloat(45)
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        return Path { path in
            path.addArc(
                center: center,
                radius: innerRadius,
                startAngle:  arcLength / 2,
                endAngle: -arcLength / 2,
                clockwise: true
            )
        }
        .strokedPath(StrokeStyle(
            lineWidth: 5,
            lineCap: .round
        ))
        .strokedPath(StrokeStyle(
            lineWidth: 2,
            lineJoin: .round
        ))
        .scale(rect.size.height / 100)
        .path(in: rect)
    }
}
