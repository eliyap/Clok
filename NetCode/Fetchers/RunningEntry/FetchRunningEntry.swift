//
//  FetchRunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class RunningEntryLoader: ObservableObject {
    private var loader: AnyCancellable? = nil
    
    /**
     Use Combine to make an async network request for the User's `RunningEntry`,
     which is not a `TimeEntry` (not stored in CoreData)
     */
    static func fetchRunningEntry(
        user: User,
        projects: [Project]
    ) -> AnyPublisher<RunningEntry, Error> {
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#get-running-time-entry
        URLSession.shared.dataTaskPublisher(for: formRequest(
            url: NetworkConstants.runningURL,
            auth: auth(token: user.token)
        ))
            .map(dataTaskMonitor)
            .tryMap { try RunningEntry(data: $0, projects: projects) ?? .noEntry }
            /**
             If project could not be found, request details and construct a `ProjectLite` with the aesthetic information
             */
            .flatMap { (running: RunningEntry) -> AnyPublisher<RunningEntry, Never> in
                if running.project == .UnknownProjectLite {
                    return ProjectLoader.projectPublisher(user: user)
                        .map { (rawProjects: [RawProject]) -> RunningEntry in
                            /// try to find a matching project in the web call, otherwise give up and leave it as `unknown`
                            /// NOTE: we may force unwrap `pid` here, as `project` being `UnknownProject` implies `pid` was not `nil`
                            if let match = rawProjects.first(where: {$0.id == running.pid}) {
                                running.project = ProjectLite(
                                    color: Color(hex: match.hex_color),
                                    name: match.name,
                                    id: Int64(match.id)
                                )
                            }
                            return running
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just(running)
                        .eraseToAnyPublisher()
                }
            }
            /// move to main thread
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
