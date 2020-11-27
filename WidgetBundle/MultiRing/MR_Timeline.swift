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
    static let widgetPeriod: TimeInterval = .hour / 4
}

struct MultiRingProvider: IntentTimelineProvider {
    
    typealias Entry = MultiRingEntry
    typealias Intent = MultiRingConfigurationIntent
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), projects: [], running: .noEntry)
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        /// fetch credentials from Keychain
        guard let (_, _, token, chosenWID) = try? getKey() else {
            completion(placeholder(in: context))
            return
        }
        
        /// fetch summary from Toggl
        fetchDetailed(token: token, wid: chosenWID, period: configuration.Period) { detailed, error in
            guard let detailed = detailed, error == nil else {
                print("MultiRingWidget Fetch Failed With Error \(String(describing: error))")
                completion(placeholder(in: context))
                return
            }
            
            /// submit fetched summary
            completion(MultiRingEntry(
                date: Date(),
                projects: detailed.projects,
                running: WidgetManager.running ?? .noEntry,
                theme: configuration.Theme
            ))
            return
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
        fetchDetailed(token: token, wid: chosenWID, period: configuration.Period) { detailed, error in
            guard let detailed = detailed, error == nil else {
                print("MultiRingWidget Fetch Failed With Error \(String(describing: error))")
                let timeline = Timeline(entries: [Entry](), policy: .after(Date() + .widgetPeriod))
                completion(timeline)
                return
            }
            
            /// add fetched summary to Widget Timeline
            /// load again after `widgetPeriod`
            let timeline = Timeline(
                entries: [MultiRingEntry(
                    date: Date(),
                    projects: detailed.projects,
                    running: WidgetManager.running ?? .noEntry,
                    theme: configuration.Theme
                )],
                policy: .after(Date() + .widgetPeriod)
            )
            completion(timeline)
            return
        }
    }
}
