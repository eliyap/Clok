//
//  FetchRunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData
final class RunningEntryLoader: ObservableObject {
    private var loader: AnyCancellable? = nil
    
    var running: RunningEntry? = nil
    
    /**
     Use Combine to make an async network request for the User's `RunningEntry`,
     which is not a `TimeEntry` (not stored in CoreData)
     */
    func fetchRunningEntry(
        user: User,
        projects: [Project],
        context: NSManagedObjectContext
    ) -> Void {
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#get-running-time-entry
        loader = URLSession.shared.dataTaskPublisher(for: formRequest(
            url: runningURL,
            auth: auth(token: user.token)
        ))
            .map(dataTaskMonitor)
            .tryMap { (data: Data) -> RunningEntry in
                return try RunningEntry(data: data, projects: projects)
            }
            /**
             If project could not be found, request a replacement
             */
            .flatMap { (running: RunningEntry) -> AnyPublisher<RunningEntry?, Never> in
                /// debug
                print(running.project.name)
                if StaticProject.unknown == running.project {
                    return ProjectLoader.projectPublisher(user: user)
                        /// move to main thread for CoreData work
                        .receive(on: DispatchQueue.main)
                        .map { (rawProjects: [RawProject]) -> RunningEntry in
                            /// try to find a matching project in the web call, otherwise give up and leave it as `unknown`
                            if let match = rawProjects.first(where: {$0.id == running.pid}) {
                                let newProject = Project(raw: match, context: context)
                                /// save new `Project`
                                try! context.save()
                                /// replace `project` and return `RunningEntry`
                                var fixed = running
                                fixed.project = newProject
                                return fixed
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
            .catch(printAndReturnNil)
            .assign(to: \.running, on: self)
    }
}
