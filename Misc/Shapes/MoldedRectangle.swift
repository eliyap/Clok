//
//  MoldedRectangle.swift
//  WidgetBundleExtension
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
struct MoldedRectangle: Shape {
    
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: .zero, y: rect.height + cornerRadius))
            path.addArc(
                center: CGPoint(x: cornerRadius, y: rect.height + cornerRadius),
                radius: cornerRadius,
                startAngle: -.tau / 2,
                endAngle: -.tau / 4,
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: rect.height))
            path.addArc(
                center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                radius: cornerRadius,
                startAngle: .tau / 4,
                endAngle: .zero,
                clockwise: true
            )
            path.addLine(to: CGPoint(x: rect.width, y: cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.width + cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: -.tau / 2,
                endAngle: -.tau / 4,
                clockwise: false
            )
            path.closeSubpath()
        }
    }
    
    
}
