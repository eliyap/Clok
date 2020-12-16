//
//  RR_Widget.swift
//  WidgetBundleExtension
//
//  Created by Secret Asian Man Dev on 29/10/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct RunningRing: Widget {
    let kind: String = "RunningRing"

    var nspc: NSPersistentContainer
    
    init(){
        nspc = makeNSPC()
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: RunningRingProvider.Intent.self,
            provider: RunningRingProvider(context: nspc.viewContext)
        ) { entry in
            RunningSquare(entry: entry)
        }
            .configurationDisplayName("Timer")
            .description("Show the running time entry.")
            .supportedFamilies([.systemSmall])
    }
}
