//
//  AngleExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


extension Angle {
    /// utility trig functions
    func cosine() -> Double {
        cos(self.radians)
    }
    func sine() -> Double {
        sin(self.radians)
    }
}

extension Angle {
    /**
     maps [0, 360) degrees to [0000,2400) hours
     time is relative to midnight today
    */
    func time24h() -> Date {
        let cal = Calendar.current
        let time = dayLength * (self.degrees / 360.0)
        return cal.startOfDay(for: Date()) + time
    }
}

extension Angle {
    /**
     initialize angle from cartesian coordinates (x,y)
     */
    init(x:Double,y:Double) {
        self.init()
        
        /// should never happen, but handle an angle at (0, 0)
        guard x != 0 || y != 0 else {
            /// should probably add runtime warning message here
            self.radians = 0.0
            return
        }
        
        /// check div / 0
        guard x != 0 else {
            if y > 0 {
                /// 90 deg, on the +y axis
                self.radians = Double.pi / 2
            } else if y < 0 {
                /// 270 deg, on the -y axis
                self.radians = -Double.pi / 2
            }
            return
        }
        
        /// check ambiguous case where y/x=0
        guard y != 0 else {
            if x > 0 {
                /// 0 deg, on the +x axis
                self.radians = 0
            } else if x < 0 {
                /// 180 deg, on the -x axis
                self.radians = Double.pi
            }
            return
        }
        
        /// normal case, simply assign calculated arctan
        self.radians = atan(y / x)
    }
}
