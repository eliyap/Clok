//
//  DateMean.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 13/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension Array where Element == Date {
    /**
     using the method detailed at https://en.m.wikipedia.org/wiki/Mean_of_circular_quantities
     averages the time of day for dates in this array
     thanks to Teoh Jing Yang and Ashwin Kumar for doing the hard googling
     time is relative to midnight today
     */
    public func meanTime() -> Date {
        /// find average coordinates on a unit circle
        let meanX = self.map{cos($0.angle.radians)}.mean
        let meanY = self.map{sin($0.angle.radians)}.mean
        
        /// find time represented by coordinates
        return Angle(x: meanX, y: meanY).time24h()
    }
}
