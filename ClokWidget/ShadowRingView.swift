//
//  ShadowRing.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ShadowRing: View {
    
    @Environment(\.colorScheme) var mode
    
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
    var weight = CGFloat(8.5)
    
    init(_ project: Summary.Project) {
        angle = Angle(radians: .tau * project.duration.mod(.hour) / .hour)
        hours = Int(project.duration / .hour)
        mins = Int(project.duration.mod(.hour) / 60)
        color = project.color
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                switch hours {
                case 0:
                    EmptyRing
                default:
                    DarkHalf
                        .rotationEffect(angle + .tau * 0.25)
                    LightHalf
                        .rotationEffect(angle + .tau * 0.75)
                }
                TimeIndicator
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    /// the darkened half of the ring
    private var DarkHalf: some View {
        Arc.semicircle
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
        Arc.semicircle
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
    
    var EmptyRing: some View {
        Circle()
            .strokeBorder(
                Color(UIColor.systemGray6),
                style: StrokeStyle(lineWidth: weight)
            )
    }
    
    private var HourArc: some View {
        EmptyView()
    }
    
    /// shows the amount of time spent on this project
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
                    Text(String(format: "%d:%02d", hours, mins))
                        .font(.system(
                            /// shrink slightly if hours are 2 digits
                                size: hours >= 10
                                    ? 14
                                    : 12,
                                design: .rounded
                        ))
                        /// lighten or darken to improve contrast
                        .foregroundColor(mode == .dark
                                            ? color.lighten()
                                            : color.darken()
                        )
                }
            }
        }
    }
}

