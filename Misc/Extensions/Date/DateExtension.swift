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

/// move back in time until date shares 24 hour time with other date
func roundDown(_ date: Date, to other: Date) -> Date {
    guard date != other else { return date }
    
    var date = date
    if other > date {
        let timeOffset = (other - date).truncatingRemainder(dividingBy: .day)
        date -= .day - timeOffset
    } else {
        let timeOffset = (date - other).truncatingRemainder(dividingBy: .day)
        date -= timeOffset
    }
    return date
}



extension Date {
    /// get the short weekday name
    /// uses "Mon" to "Sun" in EN, hopefully translates well to other languages
    public func shortWeekday() -> String {
        DateFormatter()
            .shortWeekdaySymbols[Calendar.current.component(
                .weekday,
                from: self
            /// fix offset from 1 indexed components to zero indexed name array
            ) - 1]
    }
}
