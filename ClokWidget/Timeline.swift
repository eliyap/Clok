//  Timeline.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import WidgetKit
import SwiftUI
import Foundation
import Intents

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), running: .noEntry)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        getRunningEntry { (running, error) in
            guard let running = running else {
                var entries: [SimpleEntry] = [
                    SimpleEntry(date: Date(), running: .noEntry),
                    SimpleEntry(date: Date() + 1.0, running: .noEntry),
                    SimpleEntry(date: Date() + 5.0, running: .noEntry)
                ]
                let timeline = Timeline(
                    entries: entries,
                    policy: .never
                )
                completion(timeline)
                return
            }
            
            let timeline = Timeline(
                entries: [SimpleEntry(date: Date(), running: running)],
                policy: .never
            )
            completion(timeline)
            return
        }
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let running: RunningEntry
}
