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
     magnitude of distance from the origin
     */
    func magnitude() -> CGFloat {
        (x*x + y*y).squareRoot()
    }
    
    /**
     angle of line from origin to point, off of the +x axis
     +ve is counter clockwise
     normalized to a [0, 360] degree range
     */
    func angle() -> Angle {
        /// take the arctan, with coordinate zero at circle's center
        var angle = Double(atan(y/x))
        
        angle += (y > 0 && x > 0) ? 0 : /// angle is in 1st quadrant, add nothing
            (x < 0) ? Double.pi : /// 2nd & 3rd quadrant, add pi
            2 * Double.pi /// 4th quardrant, add 2 pi
        return Angle(radians: angle)
    }
}
