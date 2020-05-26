//
//  Constants.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: Drawing Constants

// controls the angle of spiral being approximated by Bezier curves
// smaller angles lead to more complex paths
let thetaStep = Double.pi / 4

// the width of a spiral arc, increasing this will leave less space between spirals
let thiccness = Double.pi * 1.25

// the maximum theta & radius allowed in the spiral,
// corresponds to 7 turns of the spiral for 7 days
let MAX_RADIUS = 7 * 2 * Double.pi

// core graphics representation of the size of an unscaled spiral
let frame_size = CGFloat(2 * (MAX_RADIUS + thiccness))

// radius of the corners, increase to make rounder corners
let corner_radius = 0.7


// MARK: API components

// lets Toggle know who I am
let user_agent = "trickl.app"

// API token needs to be provided by the User
let myToken = "cfae5db4249b8509ca7671259598c2fb"


let myUsername = "TricklTest"
let myWorkspace = "3109909"


// MARK: Time Constants

let dayLength = TimeInterval(24 * 60 * 60)
let weekLength: TimeInterval = 7 * dayLength

// the length of an Archimedean Spiral with a = 0, b = 1, from 0 to 14 pi
// https://www.wolframalpha.com/input/?i=integrate+sqrt%28x%5E2%2B1%29dx+from+0+to+14pi
let weekSpiralLength = NSNumber(969.7)
enum Weekdays: Int {
    case Sunday = 0
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
}
