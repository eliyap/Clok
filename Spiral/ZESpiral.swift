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
    
    public var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(theta1, theta2)
        }
        set {
            (self.theta1, self.theta2) = (newValue.first, newValue.second)
        }
    }
    
    init(theta1: Angle, theta2: Angle){
        /// cap angles at the end of the spiral
        self.theta1 = min(MAX_RADIUS, theta1.radians)
        self.theta1 = max(0, self.theta1)
        self.theta2 = min(MAX_RADIUS, theta2.radians)
        self.theta2 = max(0, self.theta2)
    }
    
    func path(in rect: CGRect) -> Path {
        /// do not draw if theta's are equal or don't make sense
        guard (theta2 > theta1) else {
            return Path()
        }
        
        var oldT = theta1
        var newT = theta1
        var oldSlope = 0.0
        var newSlope = 0.0
        
        var firstSlope = true
        
        /// calculate the angle subtended by the rounded corners (drops off further from the center)
        let del1 = (theta1 == 0) ? (corner_radius) : (corner_radius / theta1)
        let del2 = (theta2 == 0) ? (corner_radius) : (corner_radius / theta2)
        
        /// approximate small arcs by rounded rectangles
        guard
            /// fails if arc is outside 2 PI and under 1/20 rad
            (theta2 > 2 * Double.pi && theta2 - theta1 > 0.05 * Double.pi) ||
            /// or inside 2 PI and under 1 rad
            (theta2 < 2 * Double.pi && theta2 - theta1 > 0.5)
        else {
            return Path.init(
                roundedRect: CGRect(
                    origin: CGPoint(
                        x:theta1,
                        y:0
                    ),
                    size: CGSize(width: thiccness, height: (theta2 - theta1) * (theta2 + theta1) / 2)),
                cornerRadius: CGFloat(corner_radius)
            )
            // rotate it into place
            .applying(CGAffineTransform(rotationAngle: CGFloat(theta1)))
            // center it
            .applying(CGAffineTransform(translationX: frame_size/2, y: frame_size/2))
        }
        
        var thetas: [Double] = []
        // iterate from start to end theta (accounting for small variation due to round cap)
        // to create a list of angles
        for t in stride(from: theta1 + del1, to: theta2 - del2, by: thetaStep){
            thetas.append(t)
        }
        thetas.append(theta2 - del2)
        
        return Path { path in
            /// draw initial quarter circle
            path.move(to: center(spiralPoint(theta: theta1, thicc: corner_radius)))
            path.addRelativeArc(
                center: center(spiralPoint(theta: theta1 + del1, thicc: corner_radius)),
                radius: CGFloat(corner_radius),
                startAngle: Angle(radians: theta1 - Double.pi / 2),
                delta: Angle(radians: -Double.pi / 2)
            )
                
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
                    to: center(spiralPoint(theta: newT, thicc: 0)),
                    control: center(intersect(
                        m1: oldSlope,
                        m2: newSlope,
                        b1: -(oldSlope * xCosX(oldT) - xSinX(oldT)),
                        b2: -(newSlope * xCosX(newT) - xSinX(newT))
                    ))
                )
            }
            
            // quarter circle out
            path.addRelativeArc(
                center: center(spiralPoint(theta: theta2 - del2, thicc: corner_radius)),
                radius: CGFloat(corner_radius),
                startAngle: Angle(radians: theta2 + Double.pi),
                delta: Angle(radians: -Double.pi / 2)
            )
            
            // quarter circle out
            path.addRelativeArc(
                center: center(spiralPoint(theta: theta2 - del2, thicc: thiccness - corner_radius)),
                radius: CGFloat(corner_radius),
                startAngle: Angle(radians: theta2 + Double.pi / 2),
                delta: Angle(radians: -Double.pi / 2)
            )
            
            // draw wider arcs back to theta1
            firstSlope = true
            for idx in stride(from: thetas.count - 1, to: 0, by: -1) {
                oldT = thetas[idx]
                newT = thetas[idx - 1]
                
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
                    to: center(spiralPoint(theta: newT, thicc: thiccness)),
                    control: center(moveOutControl(pt: intersect(
                        m1: oldSlope,
                        m2: newSlope,
                        b1: -(oldSlope * xCosX(oldT) - xSinX(oldT)),
                        b2: -(newSlope * xCosX(newT) - xSinX(newT))
                    ),
                                                   theta: (oldT + newT) / 2,
                                                   phi: newT - oldT
                    ))
                )
            }
            
            // draw final quarter curve
            path.addRelativeArc(
                center: center(spiralPoint(theta: theta1 + del1, thicc: thiccness - corner_radius)),
                radius: CGFloat(corner_radius),
                startAngle: Angle(radians: theta1 + del1),
                delta: Angle(radians: -Double.pi / 2)
            )
            
            // close it up
            path.closeSubpath()
        }
    }
}


