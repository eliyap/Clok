//
//  SemiCircle.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SemiCircle: InsettableShape {
    
    var insetAmount: CGFloat = .zero
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        return SemiCircle(insetAmount: insetAmount + amount)
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addArc(
                center: CGPoint(
                    x: rect.width / 2,
                    y: rect.height / 2
                ),
                radius: rect.width / 2 - insetAmount,
                startAngle: .zero,
                endAngle: .tau/2,
                clockwise: true
            )
        }
    }
}

