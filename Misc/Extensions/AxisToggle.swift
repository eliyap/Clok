//
//  AxisToggle.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension Axis {
    mutating func toggle() -> Void {
        switch self {
        case .horizontal:
            self = .vertical
        case .vertical:
            self = .horizontal
        }
    }
}
