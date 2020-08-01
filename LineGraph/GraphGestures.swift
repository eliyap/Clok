//
//  GraphGestures.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
extension Controller {
    
    struct PositionTracker {
        @EnvironmentObject var zero: ZeroDate
        
        var lag = CGPoint.zero
        var lead = CGPoint.zero
        var intervalDiff = TimeInterval.zero /// number of days represented by the handle's change in angle
        var dayDiff = 0.0
        
        mutating func update(state: DragGesture.Value, size: CGSize) -> Void {
            /// get change in position
            lead = state.location - state.startLocation
            
            /**
            restrict scroll to dominant direction (whether that's vertical or horizontal)
            this prevents crooked swipes from accidentally moving in an undesired direction
            */
            /// check whether recent movement was more vertical or more horizontal
            /// and increment the correct tracker
            if abs(lead.x - lag.x) > abs(lead.y - lag.y) {
                /// normalize against view width
                dayDiff += Double(CGFloat(zero.dayCount) * (lead.x - lag.x) / size.width)
            } else {
                intervalDiff += Double((lead.y - lag.y) / size.height)
            }
            
            lag = lead /// remember state for next time
        }
        
        mutating func reset() -> Void {
            lead = .zero
            lag = .zero
            intervalDiff = .zero
            dayDiff = .zero
        }
        
        mutating func harvestInterval() -> TimeInterval {
            defer { intervalDiff = .zero }
            return intervalDiff
        }
        
        /// if gesture is more than 1 day in either direction, return that, and subtract the result
        mutating func harvestDays() -> Int {
            /// NOTE: apparently `.remainder(dividingBy) turns 0.5 -> -0.5, which is just bad, Apple`
            defer { dayDiff = dayDiff - Double(Int(dayDiff)) }
            return Int(dayDiff)
        }
    }
}
