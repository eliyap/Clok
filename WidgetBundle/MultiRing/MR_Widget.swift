//
//  MultiRingWidget.swift
//  Clok
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct MultiRing: Widget {
    
    let kind: String = "MultiRing"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: MultiRingConfigurationIntent.self,
            provider: MultiRingProvider()
        ) { entry in
            MultiRingEntryView(entry: entry)
        }
            .configurationDisplayName("Summary")
            .description("See the projects you've spent time on today.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}
