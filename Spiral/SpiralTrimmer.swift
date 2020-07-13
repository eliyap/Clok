//
//  SpiralTrimmer.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.07.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct SpiralPart : Shape {
    
    var start: CGFloat
    var end: CGFloat
    var rotate: Double
    
    public var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, Double>> {
        get {
            AnimatablePair(start, AnimatablePair(end, rotate))
        }
        set {
            start = newValue.first
            end = newValue.second.first
            rotate = newValue.second.second
        }
    }
    
    let wholeSpiral = Spiral(
        theta1: 0,
        theta2: MAX_RADIUS
    )
        .path(in: CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 100
        ))
    
    init?(entry: TimeEntry, zero: Date){
        (start, end) = entry.getDimensions(zero: zero)
        // do not draw spirals that are out of bounds
        guard end > 0 else { return nil }
        guard start < 1 else { return nil }
        
        rotate = zero.unboundedClockAngle24().radians
        
        /// adjust for the stroke cap
        end -= stroke_width / weekSpiralLength
        
        /// if that adjustment is too big, approximate by a sliver
        if (end < start) { end = start + 0.0001 }
    }
    
    func path (in rect:CGRect) -> Path {
        wholeSpiral
            .trimmedPath(from: start, to: end)
            .multiTransform(rect: rect, rotate: Angle(degrees: rotate))
    }
    
}

/**
 returns the length of an archimedian spiral from \theta = 0 to our angle
- based on a spiral with eqn r = \theta
- theta is in radians
 */
func archimedianSpiralLength(_ radians:Double) -> CGFloat {
    guard radians > 0 else { return CGFloat.zero }
    
    let theta = CGFloat(radians)
    return 0.5 * (theta * (theta * theta + 1.0).squareRoot() + asinh(theta))
}

extension Path {
    /**
     Applies 4 transformations to make our path presentable.
     - stroke before scale, so that the thickness is consistent across sizes
     - offset before scale, otherwise graph is off center
     */
    func multiTransform(rect:CGRect, rotate: Angle) -> Path {
        self
            .strokedPath(StrokeStyle(
                lineWidth: stroke_width,
                lineCap: .butt
            ))
            .strokedPath(StrokeStyle(
                lineWidth: stroke_width,
                lineCap: .round,
                lineJoin: .round
            ))
            .offset(x: rect.size.width / 2, y: rect.size.height / 2)
            .scale(rect.size.width / 100)
            .rotation(rotate)
            .path(in: rect)
    }
}
