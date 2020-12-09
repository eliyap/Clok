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
        guard let raw = raw.data else {
            return .noEntry
        }
        
        /// perform project matching
        let project: StaticProject!
        if raw.pid == nil {
            project = StaticProject.noProject
        } else if let match = self.projects.first(where: {$0.id == raw.pid}) {
            project = StaticProject(name: match.name, color: match.color, id: match.id)
        } else {
            project = StaticProject.unknown
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
