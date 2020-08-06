//
//  Divisions.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
fileprivate let minSize = 35 /// allocate at least this amount of space per division

/// ways to divide 24 hours into equal portions
func evenDivisions(for height: CGFloat) -> Int {
    [
        2,
        3,
        4,
        6,
        8,
        12,
        24,
        24 * 2, /// half hour
        24 * 4  /// quarter hour
    ]
        /// choose whichever guarantees at least `minSize` to each division
        .filter{minSize * $0 < Int(height)}
        .last ?? 1 /// default to 1
}
