//  ZESpiral.swift
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  based on ZESpiral by ZevEisenberg @
//  https://github.com/ZevEisenberg/ZESpiral

import Foundation
import SwiftUI

// main workhorse
struct Spiral: Shape {
    var theta1: Double
    var theta2: Double
    var rotate: Angle
    
    public var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(theta1, theta2)
        }
        set {
            (self.theta1, self.theta2) = (newValue.first, newValue.second)
        }
    }
    
    init(theta1: Double, theta2: Double, rotation: Angle){
        /// cap angles at the end of the spiral
        self.theta1 = min(MAX_RADIUS, theta1)
        self.theta2 = min(MAX_RADIUS, theta2)
        self.rotate = rotation
    }
    
    func path(in rect: CGRect) -> Path {
        
        /// do not draw if theta's are equal or misordered
        guard (theta2 - theta1 > 0) else {
            return Path()
        }
        
        var oldT = theta1
        var newT = theta1
        var oldSlope = 0.0
        var newSlope = 0.0
        
        var firstSlope = true
        var thetas: [Double] = []
        // iterate from start to end theta (accounting for small variation due to round cap)
        // to create a list of angles
        for t in stride(from: theta1, to: theta2, by: thetaStep){
            thetas.append(t)
        }
        thetas.append(theta2)
        
        return Path { path in
            /// draw initial quarter circle
            path.move(to: center(frame: rect, pt: spiralPoint(theta: theta1, thicc: 0)))
            
            // draw arcs out to theta2
            for idx in stride(from: 0, to: thetas.count - 1, by: +1) {
                oldT = thetas[idx]
                newT = thetas[idx + 1]
                
                if (firstSlope){
                    oldSlope = (sin(oldT) + newT * cos(oldT)) /
                               (cos(oldT) - newT * sin(oldT))
                    firstSlope = false
                }
                else{
                    oldSlope = newSlope
                }
                newSlope = (sin(newT) + xCosX(newT)) /
                           (cos(newT) - xSinX(newT))
                
                path.addQuadCurve(
                    to: center(frame: rect, pt: spiralPoint(theta: newT, thicc: 0)),
                    control: center(frame: rect, pt: intersect(
                        m1: oldSlope,
                        m2: newSlope,
                        b1: -(oldSlope * xCosX(oldT) - xSinX(oldT)),
                        b2: -(newSlope * xCosX(newT) - xSinX(newT))
                    ))
                )
            }
        }
        .rotation(rotate).path(in: rect)
        .strokedPath(StrokeStyle(
            lineWidth: rect.width / 20,
            lineCap: .butt
        ))
    }
}


