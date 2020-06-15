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
    var lead = Angle()
    var lag = Angle()
    var turns = Angle()
    var dayDiff = 0.0
    
    /// min angle jump to register a complete rotation
    private let threshold = Angle(degrees: 270)
    
    mutating func update(geo: GeometryProxy, value: DragGesture.Value) -> Void {
        /// get angle
        lead = CGPoint(x:
            value.location.x - geo.size.width / 2,
            y: geo.size.width / 2 - value.location.y
        ).angle() + turns
        
        /// Lead - Lag comparison allows us to detect rollover (i.e. complete rotations)
        /// if angle dramatically increases, deduct 1 clockwise turn
        if lead - lag > threshold {
            turns -= Angle(degrees: 360)
            lead -= Angle(degrees: 360)
        }
        /// if angle dramatically decreases, add 1 clockwise turn
        if lead - lag < -threshold {
            turns += Angle(degrees: 360)
            lead += Angle(degrees: 360)
        }
        
        /// update the tracked time difference
        dayDiff -= (lead - lag).degrees / 360.0
        
        lag = lead
    }
    
    mutating func harvest() -> Double {
        defer { dayDiff = 0 }
        return dayDiff
    }
    
    
}


struct KnobView: View {
    @State var angleTracker = KnobAngle()
    @State var needsDraw = false
    @EnvironmentObject var zero:ZeroDate
    
    var body: some View {
        
        GeometryReader { geo in
            HandleView()
                /// maintain rotating while dragging & while released
                .rotationEffect(-self.angleTracker.lead)
                .gesture(DragGesture()
                    .onChanged { value in
                        /// find cursor's angle
                        self.needsDraw.toggle()
                        if self.needsDraw {
                            self.zero.date += dayLength * self.angleTracker.harvest()
                        }
                        self.angleTracker.update(geo: geo, value: value)
                    }
                    .onEnded { value in
                        /// update once more on end
                        self.angleTracker.update(geo: geo, value: value)
                        self.zero.date += dayLength * self.angleTracker.harvest()
                    }
                )
                .animation(.spring())
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.angleTracker.lead = -self.zero.date.clockAngle24()
            self.angleTracker.lag = self.angleTracker.lead
        }
    }
}

