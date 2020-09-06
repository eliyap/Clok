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
        GeometryReader{ geo in
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
                GeometryReader { geo in
                    HStack {
                        Rings(project: project, size: geo.size)
                        Text(project.name)
                            .foregroundColor(project.color)
                            .font(.caption)
                            .layoutPriority(1)
                    }
                }
            }
        }
    }
    
    func Rings(project: Summary.Project, size: CGSize) -> some View {
        let remainder = project.duration.remainder(dividingBy: .hour) / .hour
        return Group {
            ForEach(0..<Int(project.duration / .hour), id: \.self) {_ in
                Circle()
                    .stroke(style: strokeStyle)
                    .frame(width: size.height, height: size.height)
                    .foregroundColor(project.color)
            }
            Arc(angle: Angle(radians: .tau * remainder))
                .frame(width: size.height, height: size.height)
                .foregroundColor(project.color)
        }
    }
}

struct Arc: Shape {
    
    let angle: Angle
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width / 2, y: .zero))
            path.addRelativeArc(
                center: CGPoint(x: rect.width / 2, y: rect.height / 2),
                radius: rect.width / 2,
                startAngle: Angle(radians: -.pi / 2),
                delta: angle
            )
            path.addRelativeArc(
                center: CGPoint(x: rect.width / 2, y: rect.height / 2),
                radius: rect.width / 2,
                startAngle: angle,
                delta: -angle
            )
        }
    }
}
