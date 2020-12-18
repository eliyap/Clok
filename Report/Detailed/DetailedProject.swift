//
//  DetailedProject.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

// MARK:- Detailed Report Project
extension Detailed {
    struct Project: Hashable {
        let color: Color
        let name: String
        let id: Int
        var entries: [Detailed.Entry]
        var duration: TimeInterval
        
        /// copy from main app to keep consistency
        static let noProject = Detailed.Project(
            color: StaticProject.NoProject.color,
            name: StaticProject.NoProject.name,
            id: Int(StaticProject.NoProject.id),
            entries: [],
            duration: .zero
        )
        
        /// placeholder project when there are not enough to populate the widget.
        static let empty = Detailed.Project(
            color: .clear,
            name: "",
            id: NSNotFound,
            entries: [],
            duration: .zero
        )
        
        mutating func append(_ entry: Detailed.Entry, config: MultiRingConfigurationIntent) {
            entries.append(entry)
            let start = config.Period == .week
                ? Date().startOfWeek(day: WidgetManager.firstDayOfWeek)
                : Date().midnight
            
            if config.PriorDay == .fromMidnight {
                /// take only the post midnight portion
                duration += (entry.end - max(start, entry.start))
            } else {
                duration += entry.dur
            }
        }
    }
}
