//
//  MR_Colors.swift
//  WidgetBundleExtension
//
//  Created by Secret Asian Man Dev on 27/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// MARK: - Adjusted Colors
extension ProjectRing {
    
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    /// not *technically* a stored property
    var colorAdjustment: CGFloat { 0.1 }
    
    var lighter: Color {
        project.color.lighten(by: colorAdjustment)
    }
    
    var darker: Color {
        project.color.darken(by: colorAdjustment)
    }
    
    /// lighten or darken to improve contrast
    var highContrast: Color {
        mode == .dark
            ? lighter
            : darker
    }
    
    /// for some reason, dark mode is returning a very dark gray, so workaround
    var modeBG: Color {
        mode == .dark
            ? .black
            : .white
    }
}

