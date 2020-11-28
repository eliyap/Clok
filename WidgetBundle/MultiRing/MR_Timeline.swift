//
//  MultiRingTimeline.swift
//  Clok
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Intents
import WidgetKit
/**
 Define the refresh rate centrally so it can be tweaked quickly
 */
fileprivate extension TimeInterval {
    static let widgetPeriod: TimeInterval = .hour / 6
}

struct MultiRingProvider: IntentTimelineProvider {
    
    typealias Entry = MultiRingEntry
    typealias Intent = MultiRingConfigurationIntent
    
    func placeholder(in context: Context) -> Entry {
        Entry(
            date: Date(),
            projects: [],
            running: .noEntry,
            config: Intent.Default
        )
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        /// fetch credentials from Keychain
        guard let (_, _, token, chosenWID) = try? getKey() else {
            completion(placeholder(in: context))
            return
        }
        
        /// fetch summary from Toggl
        DataFetcher.shared.AssignCancellable(
            pub: DetailedReportRequest(
                token: token,
                wid: chosenWID,
                config: configuration
            )
                .zip(RawRunningEntryRequest())
                .eraseToAnyPublisher()
        ) { result in
            switch result {
            case .failure(let error):
                print("MultiRingWidget Fetch Failed With Error \(String(describing: error))")
                completion(placeholder(in: context))
            case .success(let (detailed, rawRunning)):
                /// submit fetched summary
                completion(MultiRingEntry(
                    date: Date(),
                    projects: detailed.projects,
                    running: detailed.match(rawRunning),
                    config: configuration
                ))
            }
        }
    }

    func getTimeline(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        /// fetch credentials from Keychain
        guard let (_, _, token, chosenWID) = try? getKey() else {
            let timeline = Timeline(entries: [Entry](), policy: .after(Date() + .widgetPeriod))
            completion(timeline)
            return
        }
        
        /// fetch summary from Toggl
        DataFetcher.shared.AssignCancellable(
            pub: DetailedReportRequest(
                token: token,
                wid: chosenWID,
                config: configuration
            )
                .zip(RawRunningEntryRequest())
                .eraseToAnyPublisher()
        ) { result in
            switch result {
            case .failure(let error):
                print("MultiRingWidget Fetch Failed With Error \(String(describing: error))")
                let timeline = Timeline(entries: [Entry](), policy: .after(Date() + .widgetPeriod))
                completion(timeline)
            case .success(let (detailed, rawRunning)):
                /// add fetched summary to Widget Timeline
                /// load again after `widgetPeriod`
                let timeline = Timeline(
                    entries: [MultiRingEntry(
                        date: Date(),
                        projects: detailed.projects,
                        running: detailed.match(rawRunning),
                        config: configuration
                    )],
                    policy: .after(Date() + .widgetPeriod)
                )
                completion(timeline)
            }
        }
    }
}
