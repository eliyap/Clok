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
    
    typealias Entry = SummaryEntry
    typealias Intent = ConfigurationIntent
    
    func placeholder(in context: Context) -> SummaryEntry {
        SummaryEntry(date: Date(), summary: .noSummary)
    }
    
    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (SummaryEntry) -> Void
    ) -> Void {
        #warning("snapshot should be better formed")
        completion(placeholder(in: context))
    }
    
    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<SummaryEntry>) -> Void
    ) -> Void {
        // fetch credentials from Keychain
        guard let (_, _, token, chosenWID) = try? getKey() else {
            let timeline = Timeline(entries: [SummaryEntry](), policy: .after(Date() + .hour))
            completion(timeline)
            return
        }
        
        // fetch summary from Toggl
        fetchSummary(token: token, wid: chosenWID) { summary, error in
            guard let summary = summary, error == nil else {
                print("Error \(String(describing: error))")
                let timeline = Timeline(entries: [SummaryEntry](), policy: .after(Date() + .hour))
                completion(timeline)
                return
            }
            
            // add fetched summary to Widget Timeline
            // load again in an hour
            let timeline = Timeline(
                entries: [SummaryEntry(date: Date(), summary: summary)],
                policy: .after(Date() + .hour)
            )
            completion(timeline)
            return
        }
    }
}
