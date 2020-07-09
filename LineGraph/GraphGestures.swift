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
        var lag = CGFloat.zero
        var lead = CGFloat.zero
        var intervalDiff = TimeInterval.zero /// number of days represented by the handle's change in angle
        
        mutating func update(state: DragGesture.Value, geo: GeometryProxy) -> Void {
            /// get change in height, normalized against view height
            lead = (state.location.y - state.startLocation.y) / geo.size.height
            intervalDiff = Double(lead - lag)
            lag = lead
        }
        
        mutating func reset() -> Void {
            lead = 0
            lag = 0
            intervalDiff = 0
        }
    }
}
