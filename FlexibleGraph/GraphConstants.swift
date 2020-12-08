//
//  GraphConstants.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

enum GraphConstants {
    /// the number of days showen in `.extendedMode`,
    /// declared a `CGFloat` because it is mostly used in that context
    static let dayCount: CGFloat = 7
    
    /** Calculations for a specific computed variable used in `HorizontalScrollStack` to restore position perfectly
     Let there be `x` days (here `x = 7`).
     Each day consumes `1 / x` of the available width (could also be height).
     To scroll a day such that `y` amount of it is on screen (`0 ≤ y ≤ 1`), we need to invoke `.scrollTo` with
     `(1 - y) * (1/x) / (1/x - 1)`. (reasoning not included here)
     This is the calculation of `(1/x) / (1/x - 1) = (1) / (1 - x)`.
     */
    static var hProp: CGFloat {
        1 / (1 - dayCount)
    }
    
    /// corresponds to being within ±2 hours of midnight
    static let midnightSnapThreshhold: CGFloat = 1/12
}
