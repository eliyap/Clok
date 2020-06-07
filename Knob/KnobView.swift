//
//  KnobView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.01.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct KnobAngle {
    var originalFrame = WeekTimeFrame()
    var lead = Angle()
    var lag = Angle()
    var rotations = 0
    var cancelled = false
    
    /// min angle jump to register a complete rotation
    private let threshold = Angle(degrees: 270)
    
    /// detects if the cursor strays outside the bounds
    /// and cancels the gesture if it does
    mutating func checkBounds(pos: CGPoint, geo: GeometryProxy) -> Bool {
        return cancelled ||
            geo.size.width * 0.4 > pos.magnitude() ||
            pos.magnitude() > geo.size.width * 0.6
    }
    
    mutating func update(geo: GeometryProxy, value: DragGesture.Value) -> Void {
        let pos = localPosition(geo: geo, value: value)
        
        /// bounds checking not enforced, see if buggy behaviour emerges
        //cancelled = checkBounds(pos: pos, geo: geo)
        
        /// refuse to respond if gesture is ended
        if cancelled { return }
        
        /// get angle
        lead = getDegrees(pos: pos)
        
        /// Lead - Lag comparison allows us to detect rollover (i.e. complete rotations)
        /// if angle dramatically increases, deduct 1 clockwise turn
        if lead - lag > threshold { rotations -= 1 }
        /// if angle dramatically decreases, add 1 clockwise turn
        if lead - lag < -threshold { rotations += 1 }
    }
    
    /// get the cursor position relative to circle's center
    func localPosition(geo: GeometryProxy, value: DragGesture.Value) -> CGPoint {
        /// +y being up and +x being rightwards,
        CGPoint(x:
            value.location.x - geo.size.width / 2,
                y: geo.size.width / 2 - value.location.y
        )
    }
    
    /// finds the angle of the tap gesture
    /// with 0 at +x axis, and +ve being CCW
    func getDegrees(pos: CGPoint) -> Angle {
        let y = pos.y
        let x = pos.x
        
        /// take the arctan, with coordinate zero at circle's center
        var angle = Double(atan(y/x))
        
        angle += (y > 0 && x > 0) ?
            /// angle is in 1st quadrant, add nothing
            0 :
            /// 2nd & 3rd quadrant, add pi
            (x < 0) ?
                Double.pi :
            /// 4th quardrant, add 2 pi
            2 * Double.pi
        return Angle(radians: angle)
    }
    
    mutating func updateFrame(_ frame:WeekTimeFrame) -> WeekTimeFrame {
        var days:Double = (lead - lag).degrees / 360.0
        days += Double(rotations)
        // - to invert time flow direction
        days *= -dayLength
        
        /// bring lag up to date
        lag = lead
        rotations = 0
        
        return frame.addingTimeInterval(days)
    }
    
    
}


struct KnobView: View {
    @State var angleTracker = KnobAngle()
    @EnvironmentObject var zero:ZeroDate
    
    var body: some View {
        
        GeometryReader { geo in
            Circle()
                .path(in: CGRect(
                    origin: CGPoint(
                        x: geo.size.width * 0.90,
                        y: geo.size.width * 0.40
                    ),
                    size: CGSize(
                        width: geo.size.width * 0.20,
                        height: geo.size.width * 0.20
                    )
                ))
                .fill(Color.red)
                /// maintain rotating while dragging & while released
                .rotationEffect(
                    withAnimation(.linear(duration: 0.25), {
                        -self.angleTracker.lead
                    })
                )
                .gesture(DragGesture()
                    .onChanged { value in
                        /// find cursor's angle
                        self.angleTracker.update(geo: geo, value: value)
                        
                        /// adjust zero date
                        self.zero.frame = self.angleTracker.updateFrame(self.zero.frame)
                        
                        /// reset rotations
                        self.angleTracker.rotations = 0
                }
                .onEnded { value in
                    /// reset cancelled indicator
                    self.angleTracker.cancelled = false
                    
                    /// reset rotation count
                    self.angleTracker.rotations = 0
                }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
