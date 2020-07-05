//
//  ClokWidget.swift
//  ClokWidget
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Foundation
import Intents

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), data: "100")
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getRunningEntry { (running, error) in
            guard let running = running else {
                var entries: [SimpleEntry] = [
                    SimpleEntry(date: Date(), data: "0"),
                    SimpleEntry(date: Date() + 1.0, data: "1"),
                    SimpleEntry(date: Date() + 5.0, data: "2")
                ]
                let timeline = Timeline(
                    entries: entries,
                    policy: .never
                )
                completion(timeline)
                return
            }
            
            let timeline = Timeline(
                entries: [SimpleEntry(date: Date(), data: running.description)],
                policy: .never
            )
            completion(timeline)
            return
        }
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let data: String
}

struct PlaceholderView : View {
    var entry: SimpleEntry
    var body: some View {
        Text("Placeholder View \(entry.data)")
    }
}

struct ClokWidgetEntryView : View {
    var entry: SimpleEntry
    var body: some View {
        Text("Actual View \(entry.data)")
    }
    
    @Environment(\.widgetFamily) var family
}

@main
struct ClokWidget: Widget {
    private let kind: String = "ClokWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView(entry: SimpleEntry(date: Date(), data: "-1"))) { entry in
            ClokWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}
