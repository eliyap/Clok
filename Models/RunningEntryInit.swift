//
//  RunningEntryInit.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
import Foundation

/** **NOTE**
 This file contains a parallel decoding of RawRunningEntry that does *not* build for Widget,
 as that created lots of import issues.
 */

fileprivate struct RawRunningEntry: Decodable {
    /// wrapped in a `data` tag, for some reason
    let data: WrappedEntry
    
    struct WrappedEntry: Decodable {
        let id: Int
        let pid: Int
        let wid: Int
        let billable: Bool
        let start: Date
        let duration: TimeInterval
        let description: String
        
        /// not sure what this represents, probably update / creation timestamp
        let at: Date
    }
}

extension RunningEntry {
    init(data: Data, projects: [Project]) throws {
        let decoder = JSONDecoder(dateStrategy: .iso8601)
        let rawRunningEntry = try decoder.decode(RawRunningEntry.self, from: data).data
        id = rawRunningEntry.id
        start = rawRunningEntry.start
        description = rawRunningEntry.description
        pid = rawRunningEntry.pid
        /**
         Since data comes from Toggl, `Project` should always be a valid project.
         If we cannot find the project in our system, mark it as unknown and try to pull it later.
         */
        project = projects.first(where: {$0.id == rawRunningEntry.pid})
            ?? StaticProject.unknown
    }
}
