//
//  ProjectRing.swift
//  MultiRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectRing: View {
    
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    static let colorAdjustment = CGFloat(0.1)
    
    var project: Detailed.Project = .empty
    var size: RingSize = .small
    
    /// Widget Configuration
    let entry: MultiRingEntry
    
    @Environment(\.colorScheme) var mode
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                switch (project, unitCount) {
                /// special case to avoid visual glitch, explicitly check if `.empty`
                case (.empty, _):
                    EmptyRing
                case (_, 0):
                    EmptyRing
                    HourArc(size: geo.size)
                        .rotationEffect(.tau * -0.25)
                    Spacer(size: geo.size)
                        .rotationEffect(angle - .tau * 0.25)
                default:
                    MultiHourRing(size: geo.size)
                        .rotationEffect(.tau * -0.25)
                    Spacer(size: geo.size)
                        .rotationEffect(angle - .tau * 0.25)
                    Beads(size: geo.size)
                        .rotationEffect(angle - .tau * 0.25)
                }
                VStack {
                    TimeIndicator
                    Text(project.name)
                        /// lighten or darken to improve contrast
                        .foregroundColor(highContrast)
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
}

extension ProjectRing {
    var unit: TimeInterval {
        switch entry.config.Period {
        case .day, .unknown:
            return .hour
        case .week:
            return .day
        }
    }
    
    /// number of complete units
    var unitCount: Int {
        Int(duration / unit)
    }
    
    /// remaining partial units
    var remainder: Double {
        (duration / unit) - Double(unitCount)
    }
    
}

// MARK: - Project Based Properties
extension ProjectRing {
    
    /// factors in the running timer, if any
    var duration: TimeInterval {
        project.duration + (entry.running.project.wrappedID == project.id
            ? Date() - entry.running.start
            : .zero
        )
    }
    
    /// the number of complete hours to be displayed
    var hours: Int {
        Int(duration / .hour)
    }
    
    /// minutes to be displayed
    var mins: Int {
        Int(duration.mod(.hour) / 60)
    }
    
    /// the angle to rotate the ring
    var angle: Angle {
        Angle(radians: .tau * remainder)
    }
}

// MARK: - Size Based Properties
extension ProjectRing {
    var nameFont: CGFloat {
        switch size {
        case .small:
            return 9
        default:
            return 16
        }
    }
    /// line weight
    var ringWeight: CGFloat{
        switch size {
        case .small:
        return 8.5
        case .large:
        return 18.5
        }
    }
    
    /// rough guess as to angle subtended by `round` cap, which extrudes from the end of the line segment
    var del: Angle {
        switch size {
        case .large:
            return Angle(radians: 0.15)
        case .small:
            return Angle(radians: 0.13)
        }
    }
    
    /// line weight of the spacing ring
    var spacerWidth: CGFloat {
        switch size {
        case .large:
            return 4
        case .small:
            return 2
        }
    }
}

// MARK: - Over 1 Hour
extension ProjectRing {
    private func  MultiHourRing(size: CGSize) -> some View {
        Group {
            DarkHalf
            LightHalf
                .rotationEffect(.tau * 0.5)
        }
        .rotationEffect(angle)
    }
    
    /// the darkened half of the ring
    private var DarkHalf: some View {
        Arc.semicircle
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: [
                        darker,
                        project.color,
                        project.color
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
                        project.color,
                        lighter,
                        project.color
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
    
    /// makes it easier to see where the boundary is
    private func Spacer(size: CGSize) -> some View {
        Group {
            /**
             when the time approaches 1 full hour, the Gradient cannot be fixed.
             So we cover the misaligned section with a solid color circle.
            **/
            Circle()
                /// 0.97 adjustment prevents a pixel perfect error around the half hour area
                .frame(width: ringWeight * 0.97, height: ringWeight * 0.97)
                .foregroundColor(lighter)
                .offset(x: (size.width - ringWeight) / 2)
            Arc(angle: .tau / 2)
                .strokeBorder(modeBG, style: StrokeStyle(lineWidth: spacerWidth))
                .frame(
                    /// 1.03 multiplier avoids a pixel perfect error around the half hour area
                    width: (ringWeight + 2 * spacerWidth) * 1.03,
                    height: (ringWeight + 2 * spacerWidth) * 1.03,
                    alignment: .leading
                )
                .offset(x: (size.width - ringWeight) / 2)
        }
    }
    
    /// counts up number of full hours
    private func Beads(size: CGSize) -> some View {
        /// the angle at which to distribute beads
        /// should allow them to just touch when at full size
        let beadAngle = 0.3
        return ForEach(0..<unitCount, id: \.self){ index in
            Circle()
                /// NOTE: to improve contrast, darken beads by extra amount
                .fill(modeBG)
                .frame(
                    width: ringWeight / 2,
                    height: ringWeight / 2
                )
                .offset(x: (size.width - ringWeight) / 2)
                .rotationEffect(-Angle(radians: beadAngle * Double(index)))
        }
    }
}

// MARK: - Under 1 Hour
extension ProjectRing {
    private func HourArc(size: CGSize) -> some View {
        let stop = CGFloat(angle.radians / .tau)
        return Group {
            Arc(angle: angle)
                .rotation(del)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: darker, location: .zero),
                            Gradient.Stop(color: lighter, location: stop)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: ringWeight, lineCap: .round)
                )
                .rotationEffect(-del)
        }
    }
    
    var EmptyRing: some View {
        Circle()
            .strokeBorder(
                Color(UIColor.systemGray6),
                style: StrokeStyle(lineWidth: ringWeight)
            )
    }
}
