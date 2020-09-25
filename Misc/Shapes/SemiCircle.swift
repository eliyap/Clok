//
//  SemiCircle.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: .zero, y: rect.height / 2))
            path.addArc(
                center: CGPoint(
                    x: rect.width / 2,
                    y: rect.height / 2
                ),
                radius: rect.height / 2,
                startAngle: .zero,
                endAngle: .tau/2,
                clockwise: true
            )
            path.closeSubpath()
        }
    }
}

