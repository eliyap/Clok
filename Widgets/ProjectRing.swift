//
//  ProjectRing.swift
//  MultiRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectRing: View {
    enum RingSize {
        case small
        case large
    }
    /// the angle at which to distribute beads
    /// should allow them to just touch when at full size
    var beadAngle = 0.3

    /// line weight
    var ringWeight = CGFloat(8.5)

    
    @Environment(\.colorScheme) var mode
    
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    static let colorAdjustment = CGFloat(0.4)

    /// the project color
    let color: Color
    
    let name: String
    
    let size: RingSize
    
    var project: Summary.Project = .empty
    
    /// the number of complete hours to be displayed
    var hours: Int {
        Int(project.duration / .hour)
    }
    
    /// minutes to be displayed
    var mins: Int {
        Int(project.duration.mod(.hour) / 60)
    }
    
    /// the angle to rotate the ring
    var angle: Angle {
        Angle(radians: .tau * project.duration.mod(.hour) / .hour)
    }
    
    init(
        _ project: Summary.Project?,
        size: RingSize = .small
    ) {
        let project = project ?? .empty
        
        
        color = project.color
        name = project.name
        
        self.size = size
        if size == .large {
            ringWeight = 18.5
        }
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
                        Beads(size: geo.size)
                    }
                    VStack {
                        TimeIndicator
                        Text(name)
                            .foregroundColor(color)
                            .font(.system(size: nameFont, design: .rounded))
                            .bold()
                            .lineLimit(1)
                    }
                    /// gives text a little more room
                    .offset(y: -5)
                }
            }
            .aspectRatio(1, contentMode: .fit)
    }
    
    private func Beads(size: CGSize) -> some View {
        ForEach(0..<hours, id: \.self){ index in
            Circle()
                .fill(darker)
                .frame(
                    width: ringWeight / 2,
                    height: ringWeight / 2
                )
                .offset(x: (size.width - ringWeight) / 2)
                .rotationEffect(
                    -Angle(radians: beadAngle * Double(index))
                    + angle
                    - .tau / 4
                )
        }
    }
    
    /// rough guess as to the extrusion angle if the round cap from the end of the line
    let del: CGFloat = 0.04
    
    /// shows the amount of time spent on this project
    private var TimeIndicator: some View {
        /// (ab)use `Group` to erase type
        Group {
            switch hours {
            case 0:
                Text("\(mins)m")
                    .font(.system(size: minuteFont, design: .rounded))
                    .bold()
                    .foregroundColor(color)
            default:
                VStack {
                    Text(String(format: "%d:%02d", hours, mins))
                        .font(.system(size: hourFont, design: .rounded))
                        .bold()
                        /// lighten or darken to improve contrast
                        .foregroundColor(mode == .dark
                            ? color.lighten(by: ProjectRing.colorAdjustment)
                            : color.darken(by: ProjectRing.colorAdjustment)
                        )
                }
            }
        }
    }
}

extension ProjectRing {
    var minuteFont: CGFloat {
        switch size {
        case .small:
            return 12
        default:
            return 20
        }
    }
    var hourFont: CGFloat {
        switch size {
        case .small:
            /// shrink slightly if hours are 2 digits
            return hours >= 10
                ? 14
                : 12
        default:
            /// shrink slightly if hours are 2 digits
            return hours >= 10
                ? 28
                : 24
        }
    }
    var nameFont: CGFloat {
        switch size {
        case .small:
            return 9
        default:
            return 16
        }
    }
}

// MARK: - Adjusted Colors
extension ProjectRing {
    var lighter: Color {
        color.lighten(by: ProjectRing.colorAdjustment)
    }
    
    var darker: Color {
        color.darken(by: ProjectRing.colorAdjustment)
    }
}

// MARK: - SemiCircles
extension ProjectRing {
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
}

// MARK: - Under 1 Hour
extension ProjectRing {
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
    
    private var EmptyRing: some View {
        Circle()
            .strokeBorder(
                Color(UIColor.systemGray6),
                style: StrokeStyle(lineWidth: ringWeight)
            )
    }
}
