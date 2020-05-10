//
//  Arc.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

func arc(
    theta1:Double,
    theta2:Double
)->RotatedShape<Path>{
    
    func scaleUp(pt:CGPoint)->CGPoint{
        return CGPoint(x: pt.x * width, y: pt.y * height)
    }
    
    guard theta2 > theta1 else {
        return Path().rotation(Angle())
    }
    
    let width = CGFloat(2 * 2 * 7 * Double.pi)
    let height = width
    let phi = theta2 - theta1
    
    return Path { path in
        path.move(
            to: CGPoint(
                x: 0,
                y: 0
            )
        )
        
        path.addLine(
            to: .init(
                x: width,
                y: 0
            )
        )
//        path.addArc(
//            tangent1End: CGPoint(x: width, y: height),
//            tangent2End: CGPoint(x: 0, y: height * 0.6),
//            radius: width
//        )
        path.addCurve(
            to: scaleUp(pt: CGPoint(
                x: cos(phi),
                y: sin(phi)
            )),
            control1: scaleUp(pt: CGPoint(
                x: 1,
                y: controlF(phi: phi)
            )),
            control2: scaleUp(pt: CGPoint(
                x:(cos(phi) + controlF(phi: phi) * sin(phi)),
                y:(sin(phi) - controlF(phi: phi) * cos(phi))
            ))
        )
        
        
        path.closeSubpath()
    }.rotation(Angle(degrees: -20), anchor: UnitPoint(x: 0, y: 0))
}

func controlF(phi: Double)->Double{
    return (4/3.0) * tan(phi/4)
}


