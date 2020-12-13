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
            .filter { $0.start.between(start, end) || $0.end.between(start, end) }
    }
}

extension TimeEntry {
    
    /// checks whether this time entry matches what the user is searching for
    func matches(_ terms: SearchTerms) -> Bool {
        switch terms.mode {
        case.projects:
            /// check whether project matches any in included projects list
            return terms.projects.first{wrappedProject == $0} != nil
        case.tags:
            fatalError("tag filtering not implemented")
        }
    }
}
