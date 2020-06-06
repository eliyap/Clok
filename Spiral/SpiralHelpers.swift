//  ZESpiral.swift
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  based on ZESpiral by ZevEisenberg @
//  https://github.com/ZevEisenberg/ZESpiral

import Foundation
import SwiftUI

// get co-ordinates of intersection of 2 lines
// defined by y = mx + b
func intersect(
    m1:Double,
    m2:Double,
    b1:Double,
    b2:Double
) -> CGPoint {
    // Note: since we control the theta-step, we can guaratantee the lines are not parallel, i.e.
    // m1 != m2, hence no need to error check
    let x = (b2 - b1) / (m1 - m2)
    return CGPoint(
        x:x,
        y:(m1*x)+b1
    )
}

// get cartesian co-ordinates of a point
// on the spiral r = theta
// and also move them out by some radius
func spiralPoint(theta:Double, thicc: Double) -> CGPoint {
    CGPoint(
        x: xCosX(theta) + cos(theta) * thicc,
        y: xSinX(theta) + sin(theta) * thicc
    )
}

/// adjust the spiral slightly off center to account for its asymmetry
let offCenter = CGPoint(
    x: -1.5 / 100.0,
    y: +2 / 100.0
)

/// adjust point to the center of frame
/// taking into account offCenter factor
func center(
    frame: CGRect,
    pt:CGPoint
) -> CGPoint{
    CGPoint(
        x: pt.x * frame.size.width / frame_size,
        y: pt.y * frame.size.height / frame_size
    ).applying(CGAffineTransform(
        translationX: frame.size.width * (0.5 + offCenter.x),
        y: frame.size.height * (0.5 + offCenter.y)
    ))
}


// helper functions
func xCosX(_ x:Double)->Double{x * cos(x)}
func xSinX(_ x:Double)->Double{x * sin(x)}
