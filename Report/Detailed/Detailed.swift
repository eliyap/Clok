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
    
    let period: Period
    
    /// Note: not sorted by duration
    var projects: [Detailed.Project] = []
    
    init(entries: [RawTimeEntry], period: Period) {
        
        var entries = entries
        self.period = period
        
        /// drop all entries that ended before cutoff time
        switch period {
        case .day, .unknown:
            entries.removeAll(where: {$0.end < Date().midnight})
        case .week:
            entries.removeAll(where: {$0.end < Date().startOfWeek(day: WidgetManager.firstDayOfWeek)})
        }
                
        /// initialize `noProject` file
        var noProject = Detailed.Project.noProject
        
        /// file away entries
        entries.forEach { rawEntry in
            if rawEntry.pid == nil {
                noProject.append(Detailed.Entry(raw: rawEntry))
            } else if let index = projects.firstIndex(where: {$0.id == rawEntry.pid}) {
                projects[index].append(Detailed.Entry(raw: rawEntry))
            } else {
                var newProject = Detailed.Project(
                    color: Color(hex: rawEntry.project_hex_color!),
                    name: rawEntry.project!,
                    id: rawEntry.pid!,
                    entries: [],
                    duration: .zero
                )
                newProject.append(Detailed.Entry(raw: rawEntry))
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
        
        mutating func append(_ entry: Detailed.Entry) {
            entries.append(entry)
            duration += entry.dur
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

        /// ignore this attributes
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
