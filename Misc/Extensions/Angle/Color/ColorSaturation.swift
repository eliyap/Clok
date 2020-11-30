//
//  ColorSaturatopn.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    
    /// Saturates a Color by the given `amount`
    /// - Parameter amount: the percentage to saturate the color by. Must be within [-1, 1]
    /// - Returns: saturated Color
    func saturated(by amount: CGFloat) -> Color {
        precondition(-1 <= amount && amount <= 1, "amount must be between -1 and 1!")
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        guard UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            #if DEBUG
            print("some problem demuxing color!")
            #endif
            return self /// return original
        }
        
        /// clamp between 0 and 1
        let adjustedSaturation = min(max(s * (1 + amount), 0), 1)
        return Color(UIColor(
            hue: h,
            saturation: adjustedSaturation,
            brightness: b,
            alpha: a
        ))
    }
    
    func desaturated(by amount: CGFloat) -> Color {
        self.saturated(by: -amount)
    }
}
