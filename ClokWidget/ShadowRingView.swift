//
//  ShadowRing.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ShadowRing: View {
    
    /// the angle to rotate the ring
    let angle: Angle
    
    /// the number of complete hours to be displayed
    let hours: Int
    
    /// the project color
    let color: Color
    
    init(_ project: Summary.Project) {
        let remainder = project.duration.remainder(dividingBy: .hour) / .hour
        angle = Angle(radians: .tau * remainder)
        hours = Int(project.duration / .hour)
        color = project.color
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                SemiCircle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                color.darken(by: colorAdjustment),
                                color.darken(by: colorAdjustment),
                                color
                            ]),
                            center: .bottom
                        ),
                        lineWidth: weight
                    )
                Circle()
                    .frame(
                        width: weight,
                        height: weight
                    )
                    .foregroundColor(color.lighten(by: colorAdjustment))
                    .offset(x: (geo.size.height - weight) / -2)
                SemiCircle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                color,
                                color,
                                color.lighten(by: colorAdjustment)
                            ]),
                            center: .bottom
                        ),
                        lineWidth: weight
                    )
                    .rotationEffect(.tau / 2)
            }
            .rotationEffect(angle + .tau / 4)
        }
        .aspectRatio(1, contentMode: .fill)
        .border(Color.green)
    }
    
    let colorAdjustment = CGFloat(0.17)
    let weight = CGFloat(7)
}

extension Color {
    func darken(by percentage: CGFloat = 0.05) -> Color {
        let (r,g,b,a) = components
        let (red, green, blue, alpha) = (
            Double(max(0, r * (1 - percentage))),
            Double(max(0, g * (1 - percentage))),
            Double(max(0, b * (1 - percentage))),
            Double(a)
        )
        return Color(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
    
    func lighten(by percentage: CGFloat = 0.05) -> Color {
        let (r,g,b,a) = components
        let (red, green, blue, alpha) = (
            Double(min(1, r * (1 + percentage))),
            Double(min(1, g * (1 + percentage))),
            Double(min(1, b * (1 + percentage))),
            Double(a)
        )
        return Color(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}
