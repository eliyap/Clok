//
//  ColorCast.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 22/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import UIKit

extension UIColor {
    
    /// A temporary fix to get around SwiftUI's broken casting.
    var color: Color {
        var (r,g,b,a) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}
