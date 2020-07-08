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
        zero.interval = max(zero.interval, 3600.0)
        zero.interval = min(zero.interval, dayLength)

        zero.date += delta / 2
    }
    
    
    func dragHandler(
        currentState: DragGesture.Value,
        gestureState: inout CGFloat,
        _: inout Transaction
    ) -> Void {
        
        gestureState = currentState
        
        /// get change in time
        let delta = Double(gestureState - magnifyBy) * dayLength * kCoeff

        /// adjust interval, but cap at reasonable quantity
        zero.interval -= delta
        zero.interval = max(zero.interval, 3600.0)
        zero.interval = min(zero.interval, dayLength)

        zero.date += delta / 2
    }
}
