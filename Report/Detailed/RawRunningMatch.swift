//
//  RawRunningMatch.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension Detailed {
    func match(_ raw: RawRunningEntry) -> RunningEntry {
        typealias DetailedProject = Detailed.Project
        guard let raw = raw.data else {
            return .noEntry
        }
        
        /// perform project matching
        var project = ProjectPresets.shared.UnknownProject
        if raw.pid == nil {
            project = ProjectPresets.shared.NoProject
        } else if let match = self.projects.first(where: {$0.id == raw.pid}) {
            /// create object in a floating `NSManagedObjectContext`
            project = FloatingProject(id: match.id, name: match.name, hex_color: match.color.toHex, context: .init(concurrencyType: .mainQueueConcurrencyType))
        } else {
            project = ProjectPresets.shared.UnknownProject
        }
        
        return (
            RunningEntry(
                id: raw.id,
                start: raw.start,
                project: project,
                entryDescription: raw.description,
                tags: raw.tags,
                billable: raw.billable
            )
        )
    }
}
