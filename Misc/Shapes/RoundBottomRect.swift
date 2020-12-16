//
//  RoundBottomRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/// Credit: https://stackoverflow.com/a/58606176
struct RoundedCornerRectangle: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct RoundBottomRect: Shape {
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let radius = rect.height / 2
            
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addRelativeArc(
                center: CGPoint(x: rect.width - radius, y: radius),
                radius: radius,
                startAngle: Angle(radians: 0),
                delta: Angle(radians: Double.pi / 2)
            )
            path.addRelativeArc(
                center: CGPoint(x: radius, y: radius),
                radius: radius,
                startAngle: Angle(radians: Double.pi / 2),
                delta: Angle(radians: Double.pi / 2)
            )
            path.closeSubpath()
        }
    }
}
