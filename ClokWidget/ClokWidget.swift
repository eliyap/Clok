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
import CoreData

@main
struct ClokWidget: Widget {
    
    private let kind: String = "ClokWidget"

    var nspc: NSPersistentContainer
    
    init() {
        nspc = makeNSPC()
    }
    
    public var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ClokConfigurationIntent.self,
            provider: Provider(context: nspc.viewContext)
        ) { entry in
            ClokWidgetEntryView(entry: entry)
        }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}
