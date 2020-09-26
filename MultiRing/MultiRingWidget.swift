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

@main
struct MultiRing: Widget {
    
    let kind: String = "MultiRing"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: MultiRingConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            MultiRingEntryView(entry: entry)
        }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}
