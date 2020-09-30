//
//  RunningRingView.swift
//  RunningRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.26.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

//
//  ProjectRing.swift
//  MultiRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let ringWeight: CGFloat = 16.5
fileprivate let padded: CGFloat = 7
fileprivate let spaced: CGFloat = 5

struct RunningEntryRing: View {
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    static let colorAdjustment = CGFloat(0.4)

    var entry: Provider.Entry
    var color: Color { entry.entry.project.wrappedColor }
    var name: String {
        if entry.entry == .noEntry {
            return ""
        } else if StaticProject.noProject  == entry.entry.project {
            return ""
        } else {
            return entry.entry.project.name
        }
    }
    var duration: TimeInterval { entry.date - entry.entry.start }
    
    /// the angle at which to distribute beads
    /// should allow them to just touch when at full size
    var beadAngle = 0.3
    
    @Environment(\.colorScheme) var mode
    
    var body: some View {
        VStack(spacing: spaced) {
            GeometryReader { geo in
                ZStack {
                    switch (entry.entry, hours) {
                    case (.noEntry, _):
                        EmptyRing
                    case (_, 0):
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
                        Text(entry.entry.description)
                            .foregroundColor(color)
                            .font(.system(size: 16, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            HStack {
                TimeIndicator
                Text(name)
                    .font(.system(size: 16, design: .rounded))
                    .bold()
                    .lineLimit(1)
                    /// lighten or darken to improve contrast
                    .foregroundColor(mode == .dark
                        ? lighter
                        : darker
                    )
            }
        }
        .padding(padded)
    }
    
    private func Beads(size: CGSize) -> some View {
        ForEach(0..<max(hours, 0), id: \.self){ index in
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
        Time
            .font(.system(size: 16, design: .rounded))
            .bold()
            /// lighten or darken to improve contrast
            .foregroundColor(mode == .dark
                ? lighter
                : darker
            )
    }
    
    private var Time: Text {
        switch entry.entry {
        case .noEntry:
            return Text(placeholderTime)
        default:
            return Text(entry.entry.start, style: .timer)
        }
    }
}

// MARK: - Project Based Properties
extension RunningEntryRing {
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
        Angle(radians: .tau * duration.mod(.hour) / .hour)
    }
}

// MARK: - Adjusted Colors
extension RunningEntryRing {
    var lighter: Color {
        color.lighten(by: RunningEntryRing.colorAdjustment)
    }
    
    var darker: Color {
        color.darken(by: RunningEntryRing.colorAdjustment)
    }
}

// MARK: - SemiCircles
extension RunningEntryRing {
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
extension RunningEntryRing {
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
