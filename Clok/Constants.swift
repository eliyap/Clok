//
//  Constants.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.18.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
// MARK: - Drawing Constants

// controls the angle of spiral being approximated by Bezier curves
// smaller angles lead to more complex paths
let thetaStep = Double.pi / 8

// the maximum theta & radius allowed in the spiral,
// corresponds to 7 turns of the spiral for 7 days
let MAX_RADIUS = 7 * 2 * Double.pi

let stroke_width = CGFloat(2.5)

// core graphics representation of the size of an unscaled spiral
let frame_size = CGFloat(2.2 * MAX_RADIUS)

extension CGFloat {
    static let nearZero = CGFloat(0.001)
}

let buttonPadding = CGFloat(7)

// MARK: - API components

// lets Toggle know who I am
let user_agent = "emlyap99@gmail.com"
let agentSuffix = "?user_agent=\(user_agent)"
let API_URL = "https://www.toggl.com/api/v8"
let REPORT_URL = "https://toggl.com/reports/api/v2/"

// https://github.com/toggl/toggl_api_docs/blob/master/chapters/users.md#get-current-user-data 
let userDataURL = URL(string:"\(API_URL)/me\(agentSuffix)")!

// https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#get-running-time-entry
let runningURL = URL(string: "\(API_URL)/time_entries/current\(agentSuffix)")!

// MARK: - Time Constants

let dayLength = TimeInterval(24 * 60 * 60)
let weekLength: TimeInterval = 7 * dayLength

// the length of an Archimedean Spiral with a = 0, b = 1, from 0 to 14 pi
// https://www.wolframalpha.com/input/?i=integrate+sqrt%28x%5E2%2B1%29dx+from+0+to+14pi
let weekSpiralLength = CGFloat(969.7)

// follows the same pattern as Calendar.current.weekdaySymbols
enum Weekdays: Int {
    case Sunday = 0
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
}

let radPerSec = Double.tau / dayLength

// MARK: - Misc
/**
 List Rows are separated by a thin grey line that runs
 from the right edge to just before the left edge
 placing rectangles in this inset gives our lists the "paper tab" look
 */
let listLineInset = CGFloat(15)

let placeholderTime = "--:--"
