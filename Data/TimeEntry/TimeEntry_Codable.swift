//
//  TimeEntryCodable.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeEntry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case start = "start"
        case duration = "duration"
        case is_billable = "is_billable"
        case pid = "pid"
        case tags = "tags"
        case created_with = "created_with"
    }
    
    public func encode(to encoder: Encoder) throws {
        /** Technical Note, Documentation @ https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#time-entries
            Toggl prefers requires `duration` and does not require `end`, whereas I prefer to treat `duration` as a consequence of `start` and `end`.
            Though I should be more careful, I will additionally perform a check here to ensure no bad data is sent to Toggl.
         */
        precondition(dur == end - start)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name ?? "",               forKey: .description)
        try container.encode(start.ISO8601,            forKey: .start)
        try container.encode(duration,                 forKey: .duration)
        try container.encode(billable,                 forKey: .is_billable)
        try container.encode(project?.wrappedID,       forKey: .pid)
        try container.encode(tagStrings,               forKey: .tags)
        try container.encode(NetworkConstants.appName, forKey: .created_with)
    }
}
