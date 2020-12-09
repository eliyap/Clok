//
//  CubicSegment.swift
//  ScrollTester
//
//  Created by Secret Asian Man Dev on 9/12/20.
//

import SwiftUI

struct QuadraticSegment: Shape {
    /** 3 sequential points in a graph.
     Values are normalized, i.e. they fall into range [0, 1]
     */
    var data: (d1: Double, d2: Double, d3: Double) /// a cubic bezier curve would require a d4, and I don't own any dice
    
    /// midpoint of d1 and d2
    var m12: Double {
        (data.d1 + data.d2) / 2
    }
    
    /// midpoint of d2 and d3
    var m23: Double {
        (data.d2 + data.d3) / 2
    }
    
    init(
        _ p1: Double?,
        _ p2: Double?,
        _ p3: Double?
    ) {
        switch (p1, p2, p3) {
        /// nothing in, nothing out
        case (nil, nil, nil):
            fatalError("No Data Supplied!")
        
        /// if only 1 data point, copy it to all 3 points
        case (.some(let p1), nil, nil):
            data = (p1, p1, p1)
        case (nil, .some(let p2), nil):
            data = (p2, p2, p2)
        case (nil, nil, .some(let p3)):
            data = (p3, p3, p3)
        
        /// if only surrounding points are supplied, interpolate the middle one
        case (.some(let p1), nil, .some(let p3)):
            data = (p1, (p1 + p3) / 2, p3)
        
        /// if one end is not supplied, replace it with the middle
        case (nil, .some(let p2), .some(let p3)):
            data = (p2, p2, p3)
        case (.some(let p1), .some(let p2), nil):
            data = (p1, p2, p2)
        
        /// all 3 points supplied
        case (.some(let p1), .some(let p2), .some(let p3)):
            data = (p1, p2, p3)
        }
        
        /// wrap around d2 if it make the absolute distance shorter
        switch data.d2 - data.d1 {
        case let x where x < -0.5:
            data.d2 += 1
        case let x where x > 0.5:
            data.d2 -= 1
        default:
            break
        }
        
        /// wrap around d3 if it make the absolute distance shorter
        switch data.d3 - data.d2 {
        case let x where x < -0.5:
            data.d3 += 1
        case let x where x > 0.5:
            data.d3 -= 1
        default:
            break
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            /// begin at the midpoint of p1 and p2
            path.move(to: CGPoint(
                x: .zero,
                y: CGFloat(m12) * rect.height
            ))
            path.addQuadCurve(
                /// end point is midpoint of p2 and p3
                to: CGPoint(
                    x: rect.width,
                    y: CGFloat(m23) * rect.height
                ),
                /// control point is p2 itself
                control: CGPoint(
                    x: rect.midX,
                    y: CGFloat(data.d2) * rect.height
                )
            )
        }
    }
}
