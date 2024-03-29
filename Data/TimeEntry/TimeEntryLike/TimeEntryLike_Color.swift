//
//  TimeEntryExtensions.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension TimeEntryLike {
    
    /// Returns a color adapted to light / dark mode
    /// - Parameter mode: whether view is in light or dark mode
    /// - Returns: adjusted `Color`
    func color(in mode: ColorScheme) -> Color {
        wrappedProject.color(in: mode)
    }
}

