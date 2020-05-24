// adapted from https://github.com/ZevEisenberg/ZESpiral/blob/master/ZESpiral.m
// ported to Swift by Elijah Yap


import Foundation
import SwiftUI

func ZELineIntersection(
    m1:CGFloat,
    b1:CGFloat,
    m2:CGFloat,
    b2:CGFloat
) -> CGPoint {
    // ensure lines are not parallel
    // crash otherwise
    assert(m1 != m2, "Lines should never be parallel!")
    let x = (b2 - b1) / (m1 - m2)
    return CGPoint(
        x: x,
        y: m1 * x + b1
    )
}

func LineSpiral(
    center:CGPoint,
    startRadius a:CGFloat,
    spacePerLoop b:CGFloat,
    startTheta:CGFloat,
    endTheta:CGFloat,
    thetaStep:CGFloat
) -> CGPath {
    let path = UIBezierPath()
    
    var oldTheta = startTheta
    var newTheta = startTheta
    
    var oldR = a + b * oldTheta
    var newR = a + b * newTheta
    
    var newPoint = CGPoint(
        x: center.x + oldR * cos(oldTheta),
        y: center.y + oldR * sin(oldTheta)
    )
    
    var oldSlope:CGFloat
    var newSlope:CGFloat = 0
    
    path.move(to: newPoint)
    
    // flags whether we are on the first slope
    var firstSlope = true;
    
    while (oldTheta < endTheta - thetaStep)
    {
        oldTheta = newTheta;
        newTheta += thetaStep;
        
        oldR = newR;
        newR = a + b * newTheta;
        
        newPoint = CGPoint(
            x: center.x + newR * cos(newTheta),
            y: center.y + newR * sin(newTheta)
        )
        
        //--------------------------------------------------
        // Slope calculation with the formula:
        // (b * sinΘ + (a + bΘ) * cosΘ) / (b * cosΘ - (a + bΘ) * sinΘ)
        //--------------------------------------------------
        let aPlusBTheta = a + b * newTheta;
        if (firstSlope)
        {
            oldSlope = (b * sin(oldTheta) + aPlusBTheta * cos(oldTheta)) /
                       (b * cos(oldTheta) - aPlusBTheta * sin(oldTheta));
            firstSlope = false;
        }
        else
        {
            oldSlope = newSlope;
        }
        newSlope = (b * sin(newTheta) + aPlusBTheta * cos(newTheta)) /
                   (b * cos(newTheta) - aPlusBTheta * sin(newTheta))
        
        var controlPoint = ZELineIntersection(
            m1: oldSlope,
            b1: -(oldSlope * oldR * cos(oldTheta) - oldR * sin(oldTheta)),
            m2: newSlope,
            b2: -(newSlope * newR * cos(newTheta) - newR * sin(newTheta))
        )
        
        //--------------------------------------------------
        // Offset the control point by the center offset.
        //--------------------------------------------------
        controlPoint.x += center.x;
        controlPoint.y += center.y;
        
        path.addQuadCurve(to: newPoint, controlPoint: controlPoint)
    }
    
    return path.cgPath;
}

