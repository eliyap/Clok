//
//  Constants.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
// constants
let thetaStep = Double.pi / 4
let thiccness = Double.pi * 1.25
let MAX_RADIUS = 7 * 2 * Double.pi
let frame_size = CGFloat(2 * (MAX_RADIUS + thiccness))
let corner_radius = 0.7


// API components
let user_agent = "trickl.app"
let myToken = "cfae5db4249b8509ca7671259598c2fb"
let myUsername = "TricklTest"
let myWorkspace = "3109909"

// convenience constants
let weekLength = TimeInterval(7 * 24 * 60 * 60)
// the length of an Archimedean Spiral with a = 0, b = 1, from 0 to 14 pi
// https://www.wolframalpha.com/input/?i=integrate+sqrt%28x%5E2%2B1%29dx+from+0+to+14pi
let weekSpiralLength = NSNumber(969.7)
