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
        let width = LineBar.thicc * geo.size.width / CGFloat(LineGraph.dayCount)
        let height = CGFloat(bound.max - bound.min) * geo.size.height
        
        /// if rect falls below bound, drop it out to hide roundedness
        let x = geo.size.width * CGFloat(Double(bound.col) / Double(LineGraph.dayCount))
        let y = CGFloat(bound.min) * geo.size.height
        return OptionalRoundRect(
            max: CGFloat(bound.max),
            min: CGFloat(bound.min),
            radius: radius
        )
            .size(CGSize(width: width, height: height))
            .position(
                x: x + geo.size.width / 2,
                y: y + geo.size.height / 2
            )
    }
    
    
}

struct OptionalRoundRect: Shape {
    
    var max: CGFloat
    var min: CGFloat
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: rect.height / 2))
            if min == .zero {
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
            if max == 1.0 {
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
