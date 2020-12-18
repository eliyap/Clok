//
//  MainAppInit.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
import Foundation

/** **NOTE**
 This file contains a parallel decoding of RawRunningEntry that does *not* build for Widget,
 in order to avoid lots of import issues.
 */

struct RawRunningEntry: Decodable {
    /// wrapped in a `data` tag, for some reason
    let data: WrappedEntry?
    
    struct WrappedEntry: Decodable {
        let id: Int64
        /// absence of a `pid` indicates no `Project`
        let pid: Int?
        let wid: Int
        let billable: Bool
        let start: Date
        let duration: TimeInterval
        let description: String
        
        /// NOTE: if there are no tags, the data is omitted
        let tags: [String]?
        
        /// not sure what this represents, probably update / creation timestamp
        let at: Date
    }
}

extension RunningEntry {
    convenience init?(data: Data, projects: [Project]) throws {
        let rawRunning = try JSONDecoder(dateStrategy: .iso8601)
            .decode(RawRunningEntry.self, from: data)
        guard let runningData = rawRunning.data else {
            /// no `data` simply means no timer is running, signal this by returning `nil`
            return nil
        }
        self.init(
            id: runningData.id,
            start: runningData.start,
            project: ProjectLike.special(.UnknownProject),
            entryDescription: runningData.description,
            tags: runningData.tags,
            billable: runningData.billable
        )
        
        /**
         Since data comes from Toggl, `Project` should always be a valid project.
         Or it can be `noProject`, represented as `nil` (i.e. the `pid` is missing in the JSON)
         If we cannot find the project in our system, mark it as unknown and try to pull it later.
         */
        if let pid = runningData.pid {
            project = projects.first(where: {$0.id == pid})
                ?? ProjectLike.special(.UnknownProject)
        } else {
            project = ProjectLike.special(.NoProject)
        }
        /// update `pid` from previously set `unknown` pid
        self.pid = project?.id
    }
}