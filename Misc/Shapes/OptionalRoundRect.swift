//
//  OptionalRoundRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct OptionalRoundRect: Shape {
    
    var radius: CGFloat
    var geoSize: CGSize
    var bound: LineBar.Bound
    
    func path(in rect: CGRect) -> Path {
        /// place with half the whitespace to center the graph
        let factor: CGFloat = (1.0 - LineBar.thicc) / 2.0
        
        /// calculate the position of the bar
        let pos = CGPoint(
            x: geoSize.width / CGFloat(LineGraph.dayCount) * factor,
            y: CGFloat(bound.min) * geoSize.height
        )
        
        return Path { path in
            var size = CGSize(
                width: LineBar.thicc * geoSize.width / CGFloat(LineGraph.dayCount),
                height: CGFloat(bound.max - bound.min) * geoSize.height
            )
            
            /// if both corners are rounded, enforce a min height to prevent corners piercing each other
            if bound.min != .zero && bound.max != 1 {
                size.height = max(size.height, 2 * radius)
            }
            
            /// starts in the middle of the right edge, and draws counter clockwise
            path.move(to: CGPoint(x: size.width, y: size.height / 2))
            
            /// top edge is clipping out -> no corner radius on top edge
            if bound.min == .zero {
                path.addLine(to: CGPoint(x: size.width, y: .zero))
                path.addLine(to: CGPoint.zero)
            } else {
                path.addRelativeArc(
                    center: CGPoint(x: size.width - radius, y: radius),
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
            if bound.max == 1 {
                path.addLine(to: CGPoint(x: .zero, y: size.height))
                path.addLine(to: CGPoint(x: size.width, y: size.height))
            } else {
                path.addRelativeArc(
                    center: CGPoint(x: radius, y: size.height - radius),
                    radius: radius,
                    startAngle: Angle(radians: Double.pi),
                    delta: -Angle(radians: Double.pi / 2)
                )
                path.addRelativeArc(
                    center: CGPoint(x: size.width - radius, y: size.height - radius),
                    radius: radius,
                    startAngle: Angle(radians: Double.pi / 2),
                    delta: -Angle(radians: Double.pi / 2)
                )
            }
            path.closeSubpath()
        }
        .applying(CGAffineTransform(translationX: pos.x, y: pos.y))
    }
}

