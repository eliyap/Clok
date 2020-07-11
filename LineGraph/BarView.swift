//
//  LineBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineBar: View {
    
    typealias Bound = (min: Double, max: Double, col: Int)
    
    @ObservedObject var entry: TimeEntry
    @EnvironmentObject private var zero: ZeroDate
    private var geo: GeometryProxy
    private let radius: CGFloat
    private let cornerScale = CGFloat(1.0/120.0);
    /// determines what proportion of available horizontal space to consume
    static let thicc = CGFloat(0.8)
    var bounds = [Bound]()
    
    var body: some View {
        ForEach(bounds, id: \.col){ bound in
            Bar(from: bound)
                .foregroundColor(entry.project.color)
        }
    }
    
    init?(
        with entry_: TimeEntry,
        geo geo_: GeometryProxy,
        bounds bounds_: [Bound]
    ){
        entry = entry_
        geo = geo_
        /// adapt scale to taste
        radius = geo.size.height * cornerScale
        bounds = bounds_
        /// if there's nothing to draw, fail the initializer
        if bounds.count == 0 {
            return nil
        }
    }
    
    func Bar(from bound: Bound) -> some View {
        /// if rect falls below bound, drop it out to hide roundedness
        let x = geo.size.width * CGFloat(Double(bound.col) / Double(LineGraph.dayCount))
            /// add a margin to center the bars in frame
            + (1 - LineBar.thicc) * geo.size.width / CGFloat(2 * LineGraph.dayCount)
        let y = CGFloat(bound.min) * geo.size.height
        return OptionalRoundRect(
            clipBot: bound.max == .zero,
            clipTop: bound.min == .zero,
            radius: radius
        )
            .size(CGSize(
                width: LineBar.thicc * geo.size.width / CGFloat(LineGraph.dayCount),
                height: CGFloat(bound.max - bound.min) * geo.size.height
            ))
            .position(
                x: x + geo.size.width / 2,
                y: y + geo.size.height / 2
            )
    }
}

struct OptionalRoundRect: Shape {
    
    var clipBot: Bool
    var clipTop: Bool
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            /// starts in the middle of the right edge, and draws counter clockwise
            path.move(to: CGPoint(x: rect.width, y: rect.height / 2))
            
            /// top edge is clipping out -> no corner radius on top edge
            if clipTop {
                path.addLine(to: CGPoint(x: rect.width, y: .zero))
                path.addLine(to: CGPoint.zero)
            } else {
                path.addRelativeArc(
                    center: CGPoint(x: rect.width - radius, y: radius),
                    radius: radius,
                    startAngle: Angle.zero,
                    delta: -Angle(radians: Double.pi / 2)
                )
                path.addRelativeArc(
                    center: CGPoint(x: radius, y: radius),
                    radius: radius,
                    startAngle: -Angle(radians: Double.pi / 2),
                    delta: -Angle(radians: Double.pi / 2)
                )
            }
            
            /// similarly decide whether to round the bottom edge
            if clipBot {
                path.addLine(to: CGPoint(x: .zero, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            } else {
                path.addRelativeArc(
                    center: CGPoint(x: radius, y: rect.height - radius),
                    radius: radius,
                    startAngle: Angle(radians: Double.pi),
                    delta: -Angle(radians: Double.pi / 2)
                )
                path.addRelativeArc(
                    center: CGPoint(x: rect.width - radius, y: rect.height - radius),
                    radius: radius,
                    startAngle: Angle(radians: Double.pi / 2),
                    delta: -Angle(radians: Double.pi / 2)
                )
            }
            path.closeSubpath()
        }
    }
    
    
}
