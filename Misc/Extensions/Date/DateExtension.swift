//
//  DateExtension.swift
//  Trickl
//
//  https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift

import Foundation
import SwiftUI


extension Date {
    /**
     whether this date falls between the 2 provided dates (inclusive)
     */
    func between(_ start:Date,_ end:Date) -> Bool {
        start <= self && self <= end
    }
}

extension Date {
    /// find the most recent `Date` that shares a 24h time with provided `Date`
    func roundDown(to other: Date) -> Date {
        guard self != other else { return self }
        
        if other > self {
            let timeOffset = (other - self).truncatingRemainder(dividingBy: .day)
            return self - (.day - timeOffset)
        } else {
            let timeOffset = (self - other).truncatingRemainder(dividingBy: .day)
            return self - timeOffset
        }
    }
}

extension Date {
    /// get the short weekday name
    /// uses "Mon" to "Sun" in EN, hopefully translates well to other languages
    var shortWeekday: String {
        DateFormatter()
            .shortWeekdaySymbols[Calendar.current.component(
                .weekday,
                from: self
            /// fix offset from 1 indexed components to zero indexed name array
            ) - 1]
    }
}

extension Date {
    /**
     returns 0000h of the first day of the week this `Date` is contained in.
     
     NOTE: the first day of the week is provided, NOT deduced from `Calendar`.
     In my testing, `Calendar`'s `.firstWeekday` straight up ignores the user's selected weekday (in Settings)
     and is just completely unreliable.
     */
    func startOfWeek(day: Int) -> Date {
        /// `day` is indexed 1 to 7, Sunday to Saturday
        precondition(1 <= day && day <= 7, "\(day) is out of range!")
        
        var date = Calendar.current.startOfDay(for: self)
        while (Calendar.current.component(.weekday, from: date) != day){
            date -= .day
        }
        return date
    }
}
