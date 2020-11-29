//
//  DetailedWithRunningFetcher.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

func DetailedWithRunningRequest(
    token: String,
    wid: Int,
    config: MultiRingConfigurationIntent
) -> AnyPublisher<(Detailed, RunningEntry), Error> {
    DetailedReportRequest(
        token: token,
        wid: wid,
        config: config
    )
        .zip(RawRunningEntryRequest())
        .flatMap { (detailed, raw) -> AnyPublisher<(Detailed, RunningEntry), Error> in
            /// no Time Entry is currently running
            guard let raw = raw.data else {
                return Just((detailed, .noEntry))
                    .tryMap{$0} /// converts `Never` to  `Error`
                    .eraseToAnyPublisher()
            }
            /// Time Entry is running, but has no project
            guard let pid = raw.pid else {
                return Just((detailed, RunningEntry(
                                id: raw.id,
                                start: raw.start,
                                project: StaticProject.noProject,
                                entryDescription: raw.description,
                                tags: raw.tags
                )))
                    .tryMap{$0} /// converts `Never` to  `Error`
                    .eraseToAnyPublisher()
            }
            /// Time Entry is running with a project in the detailed report
            if let match = detailed.projects.first(where: {$0.id == pid}) {
                return Just((detailed, RunningEntry(
                                id: raw.id,
                                start: raw.start,
                                project: StaticProject(name: match.name, color: match.color, id: match.id),
                                entryDescription: raw.description,
                                tags: raw.tags
                )))
                    .tryMap{$0} /// converts `Never` to  `Error`
                    .eraseToAnyPublisher()
            } else {
            /// Time Entry is running with some unknown project
            /// make a further request to get some details
                return FetchProjectDetails(pid: pid, token: token)
                    .map { staticProject in
                        (detailed, RunningEntry(
                            id: raw.id,
                            start: raw.start,
                            project: staticProject,
                            entryDescription: raw.description,
                            tags: raw.tags
                        ))
                    }
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
}
