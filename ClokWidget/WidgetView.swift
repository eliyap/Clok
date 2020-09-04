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
    
    var entry: SummaryEntry
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                if entry.summary == .noSummary {
                    Text("Nothing Here")
                } else {
                    Text("Awaiting Graphics")
                }
            }
        }
        .padding()
    }
}
