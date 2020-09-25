//
//  WidgetView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

fileprivate let strokeStyle = StrokeStyle(
    lineWidth: 4,
    lineCap: .round
)

fileprivate let rowCount = 4

struct ClokWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: SummaryEntry
    
    var body: some View {
        Graph()
    }
    
    func Graph() -> some View {
        let (p0, p1, p2, p3) = top4()
        return GeometryReader { geo in
            VStack(spacing: .zero) {
                HStack(spacing: .zero) {
                    ProjectLine(project: p0, size: geo.size)
                    ProjectLine(project: p1, size: geo.size)
                }
            
                HStack(spacing: .zero) {
                    ProjectLine(project: p2, size: geo.size)
                    ProjectLine(project: p3, size: geo.size)
                }
            }
        }
    }
    
    func ProjectLine(project: Summary.Project?, size: CGSize) -> some View {
        VStack(spacing: .zero) {
            if let project = project {
                ShadowRing(project)
                    .padding()
                Text(project.name)
                    .foregroundColor(project.color)
                    .font(.caption)
                    .lineLimit(1)
                    .layoutPriority(1)
            } else {
                Text("nil")
            }
        }
        .border(Color.red)
        .frame(
            width: size.width / 2,
            height: size.height / 2
        )
    }
    
    /// returns the 4 projects with the highest duration (if there are that many)
    func top4() -> (Summary.Project?, Summary.Project?, Summary.Project?, Summary.Project?) {
        let projs = entry.summary.projects.sorted(by: {$0.duration > $1.duration})
            + Array(repeating: nil, count: rowCount)
        return (
            projs[0],
            projs[1],
            projs[2],
            projs[3]
        )
    }
}
