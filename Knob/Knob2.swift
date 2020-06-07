//
//  KnobView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.01.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct KnobAngle2 {
    var originalFrame = WeekTimeFrame()
    var lead = Angle()
    var lag = Angle()
    var rotations = 0
    
    /// min angle jump to register a complete rotation
    private let threshold = Angle(degrees: 270)
    
    mutating func update(geo: GeometryProxy, value: DragGesture.Value) -> Void {
        let pos = localPosition(geo: geo, value: value)
        
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


struct KnobView2: View {
    @State var angleTracker = KnobAngle()
    @State var needsDraw = false
    
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
                    withAnimation(.easeInOut(duration: 0.5), {
                        -self.angleTracker.lead
                    })
                )
                .gesture(DragGesture()
                    .onChanged { value in
                        /// find cursor's angle
                        self.angleTracker.update(geo: geo, value: value)
                        
                        /// adjust zero date
                        self.needsDraw.toggle()
                        if self.needsDraw {
                            
                        }
                        
                    }
                    .onEnded { value in
                        /// reset rotation count
                        self.angleTracker.rotations = 0
                    }
                )
                .animation(.spring())
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

