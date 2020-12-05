//
//  TimeConstants.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreGraphics

/// No Case Enum to store constants
enum TimeConstants {
    /// indicates that no valid time interval is available
    static let placeholderTime = "--:--"
    
    /// how long to wait in seconds before fetching the `RunningTimer` again
    static let runningTimerFetchInterval: TimeInterval = 10
}

