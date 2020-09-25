//
//  ShadowRing.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ShadowRing: View {
    
    /// the angle to rotate the ring
    let angle: Angle
    
    /// the number of complete hours to be displayed
    let hours: Int
    
    /// minutes to be displayed
    let mins: Int
    
    /// the project color
    let color: Color
    
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    let colorAdjustment = CGFloat(0.2)
    
    /// line weight
    let weight = CGFloat(8.5)
    
    init(_ project: Summary.Project) {
        angle = Angle(radians: .tau * project.duration.mod(.hour) / .hour)
        hours = Int(project.duration / .hour)
        mins = Int(project.duration.mod(.hour) / 60)
        color = project.color
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                DarkHalf
                    .rotationEffect(angle + .tau * 0.25)
                LightHalf
                    .rotationEffect(angle + .tau * 0.75)
                VStack {
                    Text("\(hours)h")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(color)
                    Text("\(mins)m")
                        .font(.system(size: 9, design: .rounded))
                        .foregroundColor(color)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    /// the darkened half of the ring
    private var DarkHalf: some View {
        SemiCircle()
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: [
                        color.darken(by: colorAdjustment),
                        color.darken(by: colorAdjustment),
                        color
                    ]),
                    center: .center
                ),
                lineWidth: weight
            )
    }
    
    /// the lighter half of the ring
    private var LightHalf: some View {
        SemiCircle()
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: [
                        /// this extra color makes the rounded tip light colored
                        color.lighten(by: colorAdjustment),
                        color,
                        color.lighten(by: colorAdjustment)
                    ]),
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: weight,
                    /// rounded tip also patches over the seam between the 2 semicircles
                    lineCap: .round
                )
            )
    }
    
    private var TimeIndicator: some View {
        /// (ab)use `Group` to erase type
        Group {
            switch hours {
            case 0:
                Text("\(mins)m")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(color)
            default:
                VStack {
                    Text("\(hours)h")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(color)
                    Text("\(mins)m")
                        .font(.system(size: 9, design: .rounded))
                        .foregroundColor(color)
                }
            }
        }
    }
}

