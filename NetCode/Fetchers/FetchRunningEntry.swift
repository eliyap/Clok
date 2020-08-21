//
//  FetchRunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

final class RunningEntryLoader: ObservableObject {
    private var loader: AnyCancellable? = nil
    
    /**
     Use Combine to make an async network request for the User's `RunningEntry`,
     which is not a `TimeEntry` (not stored in CoreData)
     */
    func fetchRunningEntry(user: User) -> Void {
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#get-running-time-entry
        URLSession.shared.dataTaskPublisher(for: formRequest(
            url: runningURL,
            auth: auth(token: user.token)
        ))
        .map(dataTaskMonitor)
        .decode(type: RunningEntry.self, decoder: JSONDecoder(dateStrategy: .iso8601))
    }
    
}
