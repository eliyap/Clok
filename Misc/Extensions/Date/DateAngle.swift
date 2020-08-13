//
//  DateAngle.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 13/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension Date {
    
    /**
     returns the angle this date would show on a 24 hour clock, with 0000h being +x direction,
     bounded 0 to 360 degrees
     */
    var angle: Angle {
        let cal = Calendar.current
        
        let mins = Double(
            cal.component(.hour, from: self) * 60 +
            cal.component(.minute, from: self) +
            cal.component(.second, from: self) / 60
        )
        
        /// 1440 mins in a day / 360 deg = 1/4
        return Angle(degrees: mins / 4.0)
    }
    
    /**
     returns the angle this date would show on a 24 hour clock, with 0000h being vertically up,
     bounded -90 to 270 degrees
     */
    public func clockAngle24() -> Angle {
        /// 90 degree deduction to bring 0000h up to vertical
        angle - Angle(degrees: 90)
    }
    
    /**
     similar to `clockAngle24`, but produces values > 360 degrees
     this is so date based rotations do not snap when crossing 0 -> 360 degrees
     */
    public func unboundedClockAngle24() -> Angle {
        /// get reference time in current time zone
        let secs = self.timeIntervalSince1970 + Double(TimeZone.current.secondsFromGMT())
    
        /// 360 deg / 24 * 60 * 60 = 1/240
        /// 90 degree deduction to bring 0000h up to vertical
        return Angle(degrees: secs/240.0) - Angle(degrees: 90)
    }
}
