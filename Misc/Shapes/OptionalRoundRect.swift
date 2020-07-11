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
    
    var clipBot: Bool /// whether the bottom should appear "clipped"
    var clipTop: Bool /// whether the top should appear "clipped"
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

