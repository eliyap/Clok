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
 in order to avoid lots of import issues.
 */

fileprivate struct RawRunningEntry: Decodable {
    /// wrapped in a `data` tag, for some reason
    let data: WrappedEntry?
    
    struct WrappedEntry: Decodable {
        let id: Int
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
    convenience init(data: Data, projects: [Project]) throws {
        let decoder = JSONDecoder(dateStrategy: .iso8601)
        guard let rawRunningEntry = try decoder.decode(RawRunningEntry.self, from: data).data else {
            /// no `data` simply means no timer is running, trust Combine to deal with the error nicely
            throw NetworkError.serialization
        }
        self.init(
            id: rawRunningEntry.id,
            start: rawRunningEntry.start,
            project: StaticProject.unknown,
            entryDescription: rawRunningEntry.description
        )
        
        /**
         Since data comes from Toggl, `Project` should always be a valid project.
         Or it can be `noProject`, represented as `nil` (i.e. the `pid` is missing in the JSON)
         If we cannot find the project in our system, mark it as unknown and try to pull it later.
         */
        if let pid = rawRunningEntry.pid {
            project = projects.first(where: {$0.id == pid})
                ?? StaticProject.unknown
        } else {
            project = StaticProject.noProject
        }
        /// update `pid` from previously set `unknown` pid
        self.pid = project.wrappedID
    }
}
