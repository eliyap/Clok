//
//  RightTriangle.swift
//  Clok
//
//  Created by Secret Asian Man 3 on 20.10.01.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct RightTriangle: InsettableShape {
    
    var insetAmount: CGFloat = .zero
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        return RightTriangle(insetAmount: insetAmount + amount)
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: .zero, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.closeSubpath()
        }
    }
}

