//
//  CGPointExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.01.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension CGPoint {
    /**
    distance to point from origin
     */
    func magnitude() -> CGFloat {
        (x*x + y*y).squareRoot()
    }
    
    /**
     angle between +ve x-axis and the line from origion to point
     angle is in radians
     +ve angle is counter clockwise
     */
    func angle() -> Angle {
        /// take the arctan, with coordinate zero at circle's center
        var angle = Double(atan(y/x))
        
        angle += (y > 0 && x > 0) ? 0 : /// angle is in 1st quadrant, add nothing
            (x < 0) ? Double.pi : /// 2nd & 3rd quadrant, add pi
            2 * Double.pi /// 4th quardrant, add 2 pi
        return Angle(radians: angle)
    }
    
    /// vector subtraction
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
}
