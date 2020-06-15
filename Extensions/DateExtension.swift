//
//  DateExtension.swift
//  Trickl
//
//  https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift

import Foundation
import SwiftUI

extension Date: Strideable {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self.addingTimeInterval(n)
    }

    public func distance(to other: Date) -> TimeInterval {
        return other - self
    }
    
    /**
     on  a 24 hour clock, with 0000h being the +y direction,
     what angle does this time translate to
     bounded from 0 to 360 degrees
     */
    public func clockAngle24() -> Angle {
        let cal = Calendar.current
        
        let mins = Double(
            cal.component(.hour, from: self) * 60 +
            cal.component(.minute, from: self) +
            cal.component(.minute, from: self) / 60
        )
        /// 1440 mins in a day / 360 deg = 1/4
        /// 90 degree deduction to bring 0000h up to vertical
        return Angle(degrees: mins / 4.0) - Angle(degrees: 90)
    }
    
    /**
     similar to the above, but produces values outside the 0 to 360 degree range
     this is so that the rotation does not snap between 0 and 360 degrees
     */
    public func unboundedClockAngle24() -> Angle {
        // get reference time since in current time zone
        let secs = self.timeIntervalSince1970 + Double(TimeZone.current.secondsFromGMT())
    
        /// 360 deg / 24 * 60 * 60 = 1/240
        /// 90 degree deduction to bring 0000h up to vertical
        return Angle(degrees: secs/240.0) - Angle(degrees: 90)
    }
}
