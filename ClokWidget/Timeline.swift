//  Timeline.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import WidgetKit
import SwiftUI
import Foundation
import Intents
import Combine

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
        
        guard let (_, _, token, chosenWID) = try? getKey() else {
            let timeline = Timeline(entries: [SimpleEntry](), policy: .after(Date() + .hour))
            completion(timeline)
            return
        }
        print("fetching")
        fetchSummary(token: token, wid: chosenWID) { _, error in
            if let error = error {
                print(error)
            }
            print("fetched")
            #warning("placeholder timeline")
            let timeline = Timeline(entries: [SimpleEntry](), policy: .after(Date() + .hour))
            completion(timeline)
            return
        }
        print("finished?")
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let running: RunningEntry
}
