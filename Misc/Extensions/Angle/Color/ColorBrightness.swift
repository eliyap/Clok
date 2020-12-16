//
//  ColorAdjust.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
extension Color {
    /// return a color with all components scalar multiplied down
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
    
    /// return a color with all components scalar multiplied up, capped at max value
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
    
    /// return the same color, but with opacity (alpha) turned down
    func clearer(by percentage: CGFloat = 0.3) -> Color {
        let (r,g,b,a) = components
        let (red, green, blue, alpha) = (
            Double(r),
            Double(g),
            Double(b),
            Double(max(0, a * (1 - percentage)))
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
