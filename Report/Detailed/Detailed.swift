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
            } else if let index = projects.firstIndex(where: {$0.id == rawEntry.pid!}) {
                projects[index].append(Detailed.Entry(raw: rawEntry), config: config)
            } else {
                var newProject = Detailed.Project(
                    color: Color(hex: rawEntry.project_hex_color!),
                    name: rawEntry.project!,
                    id: Int64(rawEntry.pid!),
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


