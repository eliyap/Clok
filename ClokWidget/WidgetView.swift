//
//  WidgetView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct ClokWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: SimpleEntry
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                if entry.running == .noEntry {
                    Text("Start a timer")
                } else {
                    Text("\(entry.running.description)")
                    Text("\(entry.running.project.name)")
                    Text(entry.running.start, style: .timer)
                        .frame(maxWidth: geo.size.width)
                }
            }
        }
        .padding()
    }
}
