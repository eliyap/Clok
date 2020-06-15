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
    /// determines the length of our handle
    private let arcLength = Angle(degrees: 30.0)
    
    /// determines the stroke of our handle
    private let thiccness = CGFloat(7)
    
    /// determines distance from the center
    private let innerRadius = CGFloat(43)
    
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
            lineWidth: thiccness,
            lineCap: .round
        ))
        .scale(rect.size.height / 100)
        .path(in: rect)
    }
}

struct HandleStyle : ViewModifier {
    func body(content:Content) -> some View {
        content
            .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color(UIColor.systemBackground).opacity(0.7), radius: 10, x: -5, y: -5)
    }
}
