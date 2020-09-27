//
//  RunningRing.swift
//  RunningRing
//
//  Created by Secret Asian Man 3 on 20.09.26.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct RunningRing: Widget {
    let kind: String = "RunningRing"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: Provider.Intent.self,
            provider: Provider()
        ) { entry in
            RunningRingEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
