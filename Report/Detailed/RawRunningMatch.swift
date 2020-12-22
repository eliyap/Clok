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
        var project = ProjectLite.UnknownProjectLite
        if raw.pid == nil {
            project = .NoProjectLite
        } else if let match = self.projects.first(where: {$0.id == raw.pid ?? .zero}) {
            /// create object in a floating `NSManagedObjectContext`
            project = ProjectLite(color: match.color, name: match.name, id: match.id)
        } else {
            project = .UnknownProjectLite
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
