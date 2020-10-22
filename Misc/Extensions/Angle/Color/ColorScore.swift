//
//  ColorScore.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 22/10/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
extension Color {
    /// a rough calculation of Color's saturation
    var saturation: CGFloat {
        let (r, g, b, _) = components
        let lightness = max(r, g, b) + min(r, g, b)
        let delta = max(r, g, b) - min(r, g, b)
        return delta / (1 - abs(lightness - 1))
    }
    
    var brightness: CGFloat {
        let (r, g, b, _) = components
        return (r + g + b) / 3
    }
}

