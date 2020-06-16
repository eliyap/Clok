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
    /**
     returns the angle this date would show on a 24 hour clock, with 0000h being vertically up,
     bounded 0 to 360 degrees
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
     similar to above, but produces values outside the 0 to 360 degree range
     this is so rotations based on date do not snap between 0 and 360 degrees
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

extension Array where Element == Date {
    /**
     returns average time of day, discarding all day, month, year information
     time zone taken into account
     */
    func averageTime() -> Date {
        let cal = Calendar.current
        let midnight:Date = cal.startOfDay(for: Date())
        
        guard self.count > 0 else {
            return midnight
        }
        
        let avg:TimeInterval = self.reduce(0, {
            /// sum time since start of day
            $0 + $1.timeIntervalSince(cal.startOfDay(for: $1))
        }) / Double(self.count) /// divide to get average time
        
        /// return avg time of day for today
        return midnight + avg
    }
}
