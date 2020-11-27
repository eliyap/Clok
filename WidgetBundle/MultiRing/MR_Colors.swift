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
    var lighter: Color {
        project.color.lighten(by: ProjectRing.colorAdjustment)
    }
    
    var darker: Color {
        project.color.darken(by: ProjectRing.colorAdjustment)
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

