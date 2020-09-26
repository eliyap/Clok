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
    
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    static let colorAdjustment = CGFloat(0.4)

    /// the angle to rotate the ring
    var angle: Angle
    
    /// the number of complete hours to be displayed
    let hours: Int
    
    /// minutes to be displayed
    let mins: Int
    
    /// the project color
    let color: Color
    
    var beadAngle = 0.4

    /// line weight
    var ringWeight = CGFloat(18.5)

    init(_ project: Summary.Project, weight: CGFloat, beadAngle: Double) {
        angle = Angle(radians: .tau * project.duration.mod(.hour) / .hour)
        hours = Int(project.duration / .hour)
        mins = Int(project.duration.mod(.hour) / 60)
        color = project.color
        ringWeight = weight
        self.beadAngle = beadAngle
    }
    
    var lighter: Color {
        color.lighten(by: ShadowRing.colorAdjustment)
    }
    
    var darker: Color {
        color.darken(by: ShadowRing.colorAdjustment)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                switch hours {
                case 0:
                    EmptyRing(ringWeight: ringWeight)
                    HourArc(size: geo.size)
                        .rotationEffect(.tau * 0.75)
                default:
                    DarkHalf
                        .rotationEffect(angle + .tau * 0.75)
                    LightHalf
                        .rotationEffect(angle + .tau * 0.25)
                    Beads(size: geo.size)
                }
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
                        darker,
                        color,
                        color
                    ]),
                    center: .center
                ),
                lineWidth: ringWeight
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
                        lighter,
                        color
                    ]),
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: ringWeight,
                    /// rounded tip also patches over the seam between the 2 semicircles
                    lineCap: .round
                )
            )
    }
    
    private func Beads(size: CGSize) -> some View {
        ForEach(1...hours, id: \.self){ index in
            Circle()
                .fill(lighter)
                .frame(
                    width: ringWeight / 2,
                    height: ringWeight / 2
                )
                .offset(x: (size.width - ringWeight) / 2)
                .rotationEffect(
                    Angle(radians: beadAngle * Double(index))
                    + angle
                    - .tau / 4
                )
        }
    }
    
    /// rough guess as to the extrusion angle if the round cap from the end of the line
    let del: CGFloat = 0.04
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
                    style: StrokeStyle(lineWidth: ringWeight, lineCap: .round)
                )
        }
        
    }
}

