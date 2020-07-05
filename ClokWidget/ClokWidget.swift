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

struct PlaceholderView : View {
    var entry: SimpleEntry
    var body: some View {
        Text("Placeholder View \(entry.running.description)")
    }
}

struct ClokWidgetEntryView : View {
    var entry: SimpleEntry
    var body: some View {
        VStack {
            Text("\(entry.running.description)")
            Text("\(entry.running.project.name)")
            Text(entry.running.start, style: .timer)
        }
    }
    @Environment(\.widgetFamily) var family
}

@main
struct ClokWidget: Widget {
    private let kind: String = "ClokWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider(),
            placeholder: PlaceholderView(
                entry: SimpleEntry(
                    date: Date(),
                    running: .noEntry))) { entry in
                        ClokWidgetEntryView(entry: entry)
                    }
                .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall])
    }
}
