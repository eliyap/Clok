//
//  RunningRingTimeline.swift
//  Clok
//
//  Created by Secret Asian Man 3 on 20.09.26.
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

struct Provider: IntentTimelineProvider {
    
    typealias Entry = RunningRingEntry
    typealias Intent = RunningRingConfigurationIntent
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), entry: .noEntry)
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), entry: .noEntry)
        completion(entry)
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
        fetchSummary(token: token, wid: chosenWID) { summary, error in
            guard let summary = summary, error == nil else {
                print("MultiRingWidget Fetch Failed With Error \(String(describing: error))")
                let timeline = Timeline(entries: [Entry](), policy: .after(Date() + .widgetPeriod))
                completion(timeline)
                return
            }
            
            /// add fetched summary to Widget Timeline
            /// load again after `widgetPeriod`
            let timeline = Timeline(
                entries: [RunningRingEntry(
                    date: Date(),
                    entry: .noEntry
                )],
                policy: .after(Date() + .widgetPeriod)
            )
            completion(timeline)
            return
        }
    }
}
