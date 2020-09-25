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

struct ClokWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: SummaryEntry
    
    var body: some View {
        Graph()
    }
    
    func Graph() -> some View {
        #warning("need more flexible assignment in future")
        let projects = topN(count: 4)
        let (p0, p1, p2, p3) = (projects[0], projects[1], projects[2], projects[3])
        
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
        .padding(7)
    }
    
    func ProjectLine(project: Summary.Project?, size: CGSize) -> some View {
        VStack(spacing: .zero) {
            if let project = project {
                ShadowRing(project)
                Text(project.name)
                    .foregroundColor(project.color)
                    .font(.caption)
                    .lineLimit(1)
            } else {
                Text("nil")
            }
        }
        .frame(
            width: size.width / 2,
            height: size.height / 2
        )
    }
    
    /// returns the `count` projects in descending order duration
    /// if there are fewer than `count` projects, the array is padded with nils
    func topN(count: Int) -> [Summary.Project?] {
        let projs = entry.summary.projects.sorted(by: {$0.duration > $1.duration})
            + Array(repeating: nil, count: count)
        return Array(projs[0..<count])
    }
}
