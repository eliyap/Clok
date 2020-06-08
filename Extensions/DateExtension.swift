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
}
