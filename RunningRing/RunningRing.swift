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
import CoreData

@main
struct RunningRing: Widget {
    let kind: String = "RunningRing"

    var nspc: NSPersistentContainer
    
    init(){
        nspc = makeNSPC()
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: Provider.Intent.self,
            provider: Provider(context: nspc.viewContext)
        ) { entry in
            RunningRingEntryView(entry: entry)
        }
            .configurationDisplayName("Timer")
            .description("Show the running time entry.")
            .supportedFamilies([.systemSmall])
    }
}
