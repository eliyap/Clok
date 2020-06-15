//
//  EntryOperations.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.15.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeEntry {
    func startsWithin(_ frame:TimeFrame) -> Bool {
        self.start.between(frame.start, frame.end)
    }
    
    func endsWithin(_ frame:TimeFrame) -> Bool {
        self.end.between(frame.start, frame.end)
    }
    
    /// whether this time entry falls completely within the provided time frame
    func fallsWithin(_ frame:TimeFrame) -> Bool {
        self.startsWithin(frame) && self.endsWithin(frame)
    }
}

extension Array where Element == TimeEntry {
    func matching(_ terms:SearchTerm) -> [TimeEntry] {
        var result = self
        if terms.byDescription {
            result = result.filter { $0.description == terms.description }
        }
        if terms.byProject {
            result = result.filter { $0.project == terms.project }
        }
        return result
    }
}
