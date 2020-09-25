//
//  Arc.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Arc: InsettableShape {
    
    let angle: Angle
    var insetAmount: CGFloat = .zero
    
    static let semicircle = Arc(angle: .tau/2)
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        return Arc(angle: angle, insetAmount: insetAmount + amount)
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addRelativeArc(
                center: CGPoint(
                    x: rect.width / 2,
                    y: rect.height / 2
                ),
                radius: rect.width / 2 - insetAmount,
                startAngle: .zero,
                delta: angle
            )
        }
    }
}
