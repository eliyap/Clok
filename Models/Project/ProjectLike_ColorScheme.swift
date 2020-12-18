//
//  ProjectLike_ColorScheme.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension ProjectLike {
    /// Returns a color adapted to light / dark mode
    /// - Parameter mode: whether view is in light or dark mode
    /// - Returns: adjusted `Color`
    func color(in mode: ColorScheme) -> Color {
        switch mode {
        case .dark:
            return color.darken(by: 0.1)
        case .light:
            return UIColor.white.tinted(with: color)
        default:
            fatalError("Unsupported color scheme!")
        }
    }
}
