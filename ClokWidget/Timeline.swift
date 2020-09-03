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
    
    typealias Entry = SimpleEntry
    typealias Intent = ConfigurationIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), running: .noEntry)
    }
    
    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) -> Void {
        let entry = SimpleEntry(date: Date(), running: .noEntry)
        completion(entry)
    }
    
    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) -> Void {
        
        guard let apiKey = try? getKey() else {
            let timeline = Timeline(entries: [SimpleEntry](), policy: .after(Date() + .hour))
            completion(timeline)
            return
        }
        
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
