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
    func magnitude() -> CGFloat {
        (x*x + y*y).squareRoot()
    }
    
    /// finds the angle of the tap gesture
    /// with 0 at +x axis, and +ve being CCW
    func angle() -> Angle {
        /// take the arctan, with coordinate zero at circle's center
        var angle = Double(atan(y/x))
        
        angle += (y > 0 && x > 0) ?
            /// angle is in 1st quadrant, add nothing
            0 :
            /// 2nd & 3rd quadrant, add pi
            (x < 0) ?
                Double.pi :
            /// 4th quardrant, add 2 pi
            2 * Double.pi
        return Angle(radians: angle)
    }
    
}
