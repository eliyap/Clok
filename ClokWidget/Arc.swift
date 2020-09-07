//
//  Arc.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

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
//            path.addRelativeArc(
//                center: CGPoint(x: rect.width / 2, y: rect.height / 2),
//                radius: rect.width / 2,
//                startAngle: angle + Angle(radians: -.pi / 2),
//                delta: -angle
//            )
        }
    }
}
