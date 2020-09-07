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

fileprivate let rowCount = 5

struct ClokWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: SummaryEntry
    
    var body: some View {
        GeometryReader{ geo in
            if entry.summary == .noSummary {
                Text("Nothing Here")
            } else {
                Graph
            }
        }
        .padding()
        .onAppear {
            print("now evaluating")
            print(solve(sizes: [
                (1, .blue),
                (12, .blue),
                (7, .blue),
            ])?.openings)
        }
    }
    
    var Graph: some View {
        VStack(alignment: .leading) {
            ForEach(
                Projects,
                id: \.0
            ) { idx, project in
                HStack {
                    ProjectLine(project: project)
                }
            }
        }
    }
    
    func ProjectLine(project: Summary.Project?) -> some View {
        Group {
            if let project = project {
                Rings(project: project)
                Text(project.name)
                    .foregroundColor(project.color)
                    .font(.callout)
                    .layoutPriority(1)
            } else {
                Text(" ")
            }
        }
    }
    
    var Projects: [(Int, Summary.Project?)] {
        Array((
            entry.summary.projects.sorted(by: {$0.duration > $1.duration})
            + Array(repeating: nil, count: rowCount)
        )[1...rowCount].enumerated())
    }
    
    func Rings(project: Summary.Project) -> some View {
        let remainder = project.duration.remainder(dividingBy: .hour) / .hour
        return Group {
            ForEach(0..<Int(project.duration / .hour), id: \.self) {_ in
                Circle()
                    .stroke(style: strokeStyle)
                    .foregroundColor(project.color)
                    .aspectRatio(1, contentMode: .fit)
            }
            ZStack {
                Circle()
                    .stroke(style: strokeStyle)
                    .foregroundColor(project.color)
                    .opacity(0.25)
                Arc(angle: Angle(radians: .tau * remainder) )
                    .stroke(style: strokeStyle)
                    .foregroundColor(project.color)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}
