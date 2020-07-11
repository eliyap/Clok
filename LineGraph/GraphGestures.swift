//
//  GraphGestures.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
extension LineGraph {
    
    /// updates the view based on the Magnification Gesture state
    func magnifyHandler(
        currentState: CGFloat,
        gestureState: inout CGFloat,
        _: inout Transaction
    ) -> Void {
        
        gestureState = currentState
        
        /// get change in time
        let delta = Double(gestureState - magnifyBy) * dayLength * kCoeff

        /// adjust interval, but cap at reasonable quantity
        zero.interval -= delta
        zero.interval = max(zero.interval, 4 * 3600.0) /// min interval: 4 hours
        zero.interval = min(zero.interval, dayLength)  /// max interval: 1 day

        zero.date += delta / 2
    }
    
    
    struct PositionTracker {
        var lag = CGPoint.zero
        var lead = CGPoint.zero
        var intervalDiff = TimeInterval.zero /// number of days represented by the handle's change in angle
        var dayDiff = 0.0
        
        mutating func update(state: DragGesture.Value, geo: GeometryProxy) -> Void {
            /// get change in position
            lead = state.location - state.startLocation
            
            /// normalize against view height
            intervalDiff = Double((lead.y - lag.y) / geo.size.height)
            
            dayDiff += Double(CGFloat(LineGraph.dayCount) * (lead.x - lag.x) / geo.size.width)
            
            /// remember state for next time
            lag = lead
        }
        
        mutating func reset() -> Void {
            lead = .zero
            lag = .zero
            intervalDiff = .zero
            dayDiff = .zero
        }
        
        /// if gesture is more than 1 day in either direction, return that, and destroy the result
        mutating func harvestDays() -> Int {
            if dayDiff < -1 {
                dayDiff += 1.0
                return -1
            }
            if dayDiff > 1 {
                dayDiff -= 1.0
                return 1
            }
            return 0
        }
    }
}
