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
    var dayDiff = TimeInterval.zero /// number of days represented by the handle's change in angle
    
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
    
    /// return, and then reset, the change in time
    mutating func harvest() -> Double {
        defer { dayDiff = 0 }
        return dayDiff
    }
    
    
}


struct KnobView: View {
    @State var angleTracker = KnobAngle()
    @State var needsDraw = false
    @EnvironmentObject var zero:ZeroDate
    @State var rotate = Angle()
    
    var body: some View {
        
        GeometryReader { geo in
            HandleView()
                /// maintain rotating while dragging & while released
                .rotationEffect(-angleTracker.lead)
                .gesture(DragGesture()
                    .onChanged { value in
                        /// find cursor's angle
                        needsDraw.toggle()
                        if needsDraw {
                            zero.date += dayLength * angleTracker.harvest()
                        }
                        angleTracker.update(geo: geo, value: value)
                    }
                    .onEnded { value in
                        /// update once more on end
                        angleTracker.update(geo: geo, value: value)
                        zero.date += dayLength * angleTracker.harvest()
                    }
                )
                .animation(.spring())
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            angleTracker.lead = -zero.date.clockAngle24()
            angleTracker.lag = angleTracker.lead
        }
        
        /// mirror the spiral's rotation effect
        .rotationEffect(rotate)
        .animation(.spring())
        .onReceive(zero.$dateChange, perform: { dxn in
            /// when a week skip command is received,
            /// perform a 360 degree barell roll animation,
            /// then reset the flag
            switch dxn {
            case .fwrd:
                rotate += Angle.tau
            case .back:
                rotate -= Angle.tau
            default:
                return
            }
        })
    }
}

