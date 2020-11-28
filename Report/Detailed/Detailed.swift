//
//  Detailed.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Detailed {
    
    let config: MultiRingConfigurationIntent
    
    /// Note: not sorted by duration
    var projects: [Detailed.Project] = []
    
    init(entries: [RawTimeEntry], config: MultiRingConfigurationIntent) {
        
        var entries = entries
        self.config = config
        
        /// drop all entries that ended before cutoff time
        switch config.Period {
        case .day, .unknown:
            if config.PriorDay == .exclude {
                entries.removeAll(where: {$0.start < Date().midnight})
            } else {
                entries.removeAll(where: {$0.end < Date().midnight})
            }
        case .week:
            let startOfWeek = Date().startOfWeek(day: WidgetManager.firstDayOfWeek)
            if config.PriorDay == .exclude {
                entries.removeAll(where: {$0.start < startOfWeek})
            } else {
                entries.removeAll(where: {$0.end < startOfWeek})
            }
        }
                
        /// initialize `noProject` file
        var noProject = Detailed.Project.noProject
        
        /// file away entries
        entries.forEach { rawEntry in
            if rawEntry.pid == nil {
                noProject.append(Detailed.Entry(raw: rawEntry), config: config)
            } else if let index = projects.firstIndex(where: {$0.id == rawEntry.pid}) {
                projects[index].append(Detailed.Entry(raw: rawEntry), config: config)
            } else {
                var newProject = Detailed.Project(
                    color: Color(hex: rawEntry.project_hex_color!),
                    name: rawEntry.project!,
                    id: rawEntry.pid!,
                    entries: [],
                    duration: .zero
                )
                newProject.append(Detailed.Entry(raw: rawEntry), config: config)
                projects.append(newProject)
            }
        }
        
        /// only include `noProject` if there are entries in it
        if noProject.entries.count > 0 {
            projects.append(noProject)
        }
    }
}

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
            color: StaticProject.noProject.wrappedColor,
            name: StaticProject.noProject.name,
            id: StaticProject.noProject.wrappedID,
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

// MARK:- Detailed Report Entry
extension Detailed {
    struct Entry: Hashable {
        let description: String
        
        let start: Date
        let end: Date
        let dur: Double
        
        let id: Int
        let billable: Bool
                
        let tags: [String]

        /// ignore these attributes
        // let updated: Date
        // let uid: Int; // user ID
        // let use_stop: Bool
        // let user: String
        
        init(raw: RawTimeEntry){
            self.description = raw.description
            self.start = raw.start
            self.end = raw.end
            self.dur = raw.dur / 1000 /// convert from ms to s
            self.id = raw.id
            self.billable = raw.is_billable
            self.tags = raw.tags
        }
    }
}
