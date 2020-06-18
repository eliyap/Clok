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
}

extension Date {
    
    public func angle() -> Angle {
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
     bounded 0 to 360 degrees
     */
    public func clockAngle24() -> Angle {
        /// 90 degree deduction to bring 0000h up to vertical
        self.angle() - Angle(degrees: 90)
    }
    
    /**
     similar to above, but produces values > 360 degrees
     this is so date based rotations do not snap when crossing 0 -> 360 degrees
     */
    public func unboundedClockAngle24() -> Angle {
        /// get reference time in current time zone
        let secs = self.timeIntervalSince1970 + Double(TimeZone.current.secondsFromGMT())
    
        /// 360 deg / 24 * 60 * 60 = 1/240
        /// 90 degree deduction to bring 0000h up to vertical
        return Angle(degrees: secs/240.0) - Angle(degrees: 90)
    }
    
    /**
     filters to only time entries that occured within a week of this date
     */
    func withinWeekOf(_ entries:[TimeEntry]) -> [TimeEntry] {
        entries.filter {
            self < $0.start && $0.start < self + weekLength ||
            self < $0.end   && $0.end   < self + weekLength
        }
    }
}

extension Date {
    /**
     whether this date falls between the 2 provided dates (inclusive)
     */
    func between(_ start:Date,_ end:Date) -> Bool {
        start <= self && self <= end
    }
}


extension Date {
    /// move back in time until self shares 24 hour time with provided date
    mutating func roundDown(to other: Date) -> Void {
        guard self != other else { return }
        if other > self {
            let timeOffset = (other - self).truncatingRemainder(dividingBy: dayLength)
            self -= dayLength - timeOffset
        } else {
            let timeOffset = (self - other).truncatingRemainder(dividingBy: dayLength)
            self -= timeOffset
        }
    }
}

extension Array where Element == Date {
    /**
     using the method detailed at https://en.m.wikipedia.org/wiki/Mean_of_circular_quantities
     average the time of day in this array
     thanks to Teoh Jing Yang and Ashwin Kumar for doing the hard googling
     time is relative to midnight today
     */
    public func meanTime() -> Date {
        /// find average coordinates on a unit circle
        let meanX = self.map{$0.angle().cosine()}.mean()
        let meanY = self.map{$0.angle().sine()}.mean()
        
        /// find time represented by coordinates
        return Angle(x: meanX, y: meanY).time24h()
    }
}
