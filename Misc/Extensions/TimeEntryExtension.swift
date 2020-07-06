//
//  TimeEntryExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension Array where Element == TimeEntry {
    func within(interval: TimeInterval, of start: Date) -> [TimeEntry] {
        let end = start + interval
        return self
            .filter { $0.start.between(start, end) || $0.start.between(start, end) }
    }
}

extension TimeEntry {
    
    /// checks whether this time entry matches what the user is searching for
    func matches(_ terms: SearchTerm) -> Bool {
        /// perform case insensitive comparison
        /// NOTE: search can be significantly improved (stemming, fuzzy matching, etc.)
        if terms.byDescription == .empty && self.description != "" {
            return false
        }
        else if terms.byDescription == .specific && self.description.caseInsensitiveCompare(terms.description) != .orderedSame {
            return false
        }
        
        if !terms.project.matches(self.project) {
            return false
        }
        
        return true
    }
    
    /// measures whether the provided time entry falls within a particular *time* range
    /// i.e. is its hand (on a 24 clock) pointing at most *x* radians after provided time
    func withinTime(lowerBound: Date, interval: TimeInterval) -> Bool {
        var startDiff = start.angle().radians - lowerBound.angle().radians
        var endDiff = end.angle().radians - lowerBound.angle().radians
        
        /// normalize to within [0, 360) degrees
        if startDiff < 0 { startDiff += Double.tau }
        if endDiff < 0 { endDiff += Double.tau }
        
        let angleInterval = interval * (Double.tau / dayLength)
        
        return startDiff < angleInterval || endDiff < angleInterval
    }
    
}
