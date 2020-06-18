//
//  AngleExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


extension Angle {
    /// utility trig functions
    func cosine() -> Double {
        cos(self.radians)
    }
    func sine() -> Double {
        sin(self.radians)
    }
}

extension Angle {
    /**
     maps [0, 360) degrees to [0000,2400) hours
     time is relative to midnight today
    */
    func time24h() -> Date {
        let cal = Calendar.current
        let time = dayLength * (self.degrees / 360.0)
        return cal.startOfDay(for: Date()) + time
    }
}
