//
//  AngleAsDate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 13/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension Angle {
    /**
     maps [0, 360) degrees to [0000,2400) hours
     time is relative to midnight today
    */
    var time24h: Date {
        let cal = Calendar.current
        let time = TimeInterval.day * (degrees / 360.0)
        return cal.startOfDay(for: Date()) + time
    }
}
