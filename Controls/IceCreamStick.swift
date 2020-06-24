//
//  IceCreamStick.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct IceCreamStick: Shape {
    var round: rounded
    
    enum rounded {
        case left
        case right
    }
    
    func path(in rect: CGRect) -> Path {
        let shapePath = Path { path in
            let radius = rect.height / 2
            
            path.move(to: CGPoint.zero)
            path.addRelativeArc(
                center: CGPoint(x: rect.width - radius, y: radius),
                radius: radius,
                startAngle: Angle(radians: -Double.pi / 2),
                delta: Angle(radians: Double.pi)
            )
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
        }
        if round == .right { return shapePath }
        else {
            return shapePath.rotation(Angle(radians: Double.pi)).path(in: rect)
        }
    }
    
    
}
