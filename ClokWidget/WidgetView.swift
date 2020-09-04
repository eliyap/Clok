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
        return GeometryReader{ geo in
            if entry.summary == .noSummary {
                Text("Nothing Here")
            } else {
                Graph
            }
        }
        .padding()
    }
    
    var Graph: some View {
        VStack(alignment: .leading) {
            ForEach(
                entry.summary.projects.sorted(by: {$0.duration > $1.duration}),
                id: \.id
            ) { project in
                HStack {
                    Rings(project: project)
                    Text(project.name)
                        .foregroundColor(project.color)
                        .font(.caption)
                        .layoutPriority(1)
                }
            }
        }
    }
    
    func Rings(project: Summary.Project) -> some View {
        ForEach(0..<Int(project.duration / .hour), id: \.self) {_ in
            Circle()
                .foregroundColor(project.color)
        }
    }
}
