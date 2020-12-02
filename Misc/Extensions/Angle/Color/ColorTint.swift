//
//  ColorToggl.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/// Toggl's implementation of color adjustment
/// Note: SwiftUI's static `Color`s are broken and don't output components, &@(*#$ knows why
extension UIColor {
    
    /// the amount that toggl blends colors
    /// https://github.com/toggl/mobileapp/blob/4426fd9eb590adf8df211750f2ddd566fe07acee/Toggl.iOS/Cells/Calendar/CalendarItemView.cs
    static let TogglTint: Double = 0.24
    
    func tinted(with tint: Color, amount: Double = TogglTint) -> Color {
        let (_r, _g, _b, _): (CGFloat, CGFloat, CGFloat, CGFloat) = tint.components
        var (r,g,b,a) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(.sRGB,
             red: Double(r) * (1 - amount) + Double(_r) * amount,
             green: Double(g) * (1 - amount) + Double(_g) * amount,
             blue: Double(b) * (1 - amount) + Double(_b) * amount,
             opacity: 1
        )
    }
}
