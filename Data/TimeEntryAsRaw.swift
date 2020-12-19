//
//  TimeEntryAsRaw.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeEntry {
    
    /** Representation of `TimeEntry` as `RawTimeEntry`.
     `RawTimeEntry` matches Toggl's API names, it only makes sense to use it as an interface back to Toggl.
     Also makes sure that my encoding / decoding keys are updated together.
     */
    var asRaw: RawTimeEntry {
        /** Technical Note, Documentation @ https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#time-entries
            Toggl prefers requires `duration` and does not require `end`, whereas I prefer to treat `duration` as a consequence of `start` and `end`.
            Though I should be more careful, I will additionally perform a check here to ensure no bad data is sent to Toggl.
         */
        precondition(dur == end - start)
        
        return RawTimeEntry(
            description: name ?? "",
            start: start,
            end: end,
            dur: dur,
            updated: Date(),                   /// - Warning: this is NOT up to me!
            id: id,
            is_billable: billable,
            pid: project?.wrappedID,
            project: project?.name,            ///   - Warning: cannot be supplied to Toggl
            project_hex_color: project?.color, ///   - Warning: cannot be supplied to Toggl
            uid: NSNotFound,                   ///   - Warning: cannot be supplied to Toggl
            use_stop: false,                   ///   - Warning: cannot be supplied to Toggl
            user: "",                          ///   - Warning: cannot be supplied to Toggl
            tags: tagStrings
        )
    }
}
