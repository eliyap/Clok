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
            .filter { $0.wrappedStart.between(start, end) || $0.wrappedEnd.between(start, end) }
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
        
        if !terms.project.matches(wrappedProject) {
            return false
        }
        
        return true
    }
}
