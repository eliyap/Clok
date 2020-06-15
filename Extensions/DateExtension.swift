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

/**
 provided a start and end date, returns an array with all midnights between those dates
 (as well as the dates themselves)
 striding over adjacent dates in resulting array gives all "day intervals" between the 2 dates,
 with non-midnight inputs resulting in partial days at the start and end (this is intentional)
 
 For testing:
 - providing 2 midnight dates should not result in duplicate values
 - 7 days (not midnight) should return a partial day, 6 full days, and a partial day (9 dates)
 - 7 days (midnight) should return 7 full days (8 dates)
 */
func daySlices(start:Date, end:Date) -> [DayFrame] {
    guard start < end else { fatalError("Invalid date range!") }
    
    var frames = [DayFrame]()
    var slices = [Date]()
    let cal = Calendar.current
    
    for d in stride(from: cal.startOfDay(for: start), through: cal.startOfDay(for: end), by: dayLength) {
        slices.append(d)
    }
    slices.remove(at: 0)
    slices.insert(start, at: 0)
    if slices.last != end { slices.append(end) }
    
    for idx in 0..<(slices.count - 1) {
        frames.append(DayFrame(start: slices[idx], end:slices[idx + 1]))
    }
    
    return frames
}
