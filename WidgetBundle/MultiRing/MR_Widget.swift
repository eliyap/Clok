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

    @Environment(\.colorScheme) var mode: ColorScheme
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: MultiRingConfigurationIntent.self,
            provider: MultiRingProvider()
        ) { entry in
            MultiRingEntryView(entry: entry)
                /// enforce the user's preferred scheme, if any, otherwise pass through the default
                .environment(\.colorScheme, {
                    switch entry.theme {
                    case .system, .unknown:
                        return mode
                    case .dark:
                        return .dark
                    case .light:
                        return .light
                    }
                }())
                .background({ () -> Color in
                    switch entry.theme {
                    case .system, .unknown:
                        return mode == .dark
                            ? .black
                            : .white
                    case .dark:
                        return .black
                    case .light:
                        return .white
                    }
                }())
        }
            .configurationDisplayName("Summary")
            .description("See the projects you've spent time on today.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}
