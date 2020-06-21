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
