//
//  GridWidget.swift
//  GridWidget
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import Intents
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: GridConfigurationIntent
}

@main
struct GridWidget: Widget {
    let kind: String = "GridWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: GridConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            GridWidgetEntryView(entry: entry)
        }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            #warning("not ready to ship")
            .supportedFamilies([])
    }
}
