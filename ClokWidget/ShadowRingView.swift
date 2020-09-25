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
    let colorAdjustment = CGFloat(0.4)
    
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
                    HourArc(size: geo.size)
                        .rotationEffect(.tau * 0.75)
                default:
                    DarkHalf
                        .rotationEffect(angle + .tau * 0.75)
                    LightHalf
                        .rotationEffect(angle + .tau * 0.25)
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
                        color,
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
                        color,
                        color.lighten(by: colorAdjustment),
                        color
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
    
    /// rough guess as to the extrusion angle if the round cap from the end of the line
    let del: CGFloat = 0.03
    private func HourArc(size: CGSize) -> some View {
        let stop = CGFloat(angle.radians / .tau)
        return Group {
            Arc(angle: angle)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: .clear, location: .zero),
                            Gradient.Stop(color: color, location: stop + del),
                            /// immediately clamp gradient back to clear, so that other cap does not show color
                            Gradient.Stop(color: .clear, location: stop + del + 0.001),
                            Gradient.Stop(color: .clear, location: 1),
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: weight, lineCap: .round)
                )
        }
        
    }
    
    /// shows the amount of time spent on this project
    private var TimeIndicator: some View {
        /// (ab)use `Group` to erase type
        Group {
            switch hours {
            case 0:
                Text("\(mins)m")
                    .font(.system(size: 12, design: .rounded))
                    .bold()
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
                        .bold()
                        /// lighten or darken to improve contrast
                        .foregroundColor(mode == .dark
                                            ? color.lighten(by: colorAdjustment)
                                            : color.darken(by: colorAdjustment)
                        )
                }
            }
        }
    }
}

