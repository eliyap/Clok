//
//  TimeEntryExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension Array where Element == TimeEntry {
    func within(interval: TimeInterval, of start: Date) -> [TimeEntry] {
        let end = start + interval
        return self
            .filter { $0.start.between(start, end) || $0.start.between(start, end) }
    }
}

extension TimeEntry {
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
}
