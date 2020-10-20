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
    
    var entry: Provider.Entry
    var size: RingSize = .large
    
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
                            .foregroundColor(highContrast)
                            .font(.system(size: 16, design: .rounded))
                            .bold()
                            .multilineTextAlignment(.center)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(translucency)
                            )
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
                    .foregroundColor(highContrast)
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
    var del: Angle {
        switch size {
        case .large:
            return Angle(radians: 0.2)
        case .small:
            return Angle(radians: 0.04)
        }
    }
    
    /// shows the amount of time spent on this project
    private var TimeIndicator: some View {
        Time
            .font(.system(size: 16, design: .rounded))
            .bold()
            /// lighten or darken to improve contrast
            .foregroundColor(highContrast)
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
        color.lighten(by: 0.1)
    }
    
    var darker: Color {
        color.darken(by: 0.1)
    }
    
    /// lighten or darken to improve contrast
    var highContrast: Color {
        mode == .dark
            ? lighter
            : darker
    }
    
    var translucency: Color {
        mode == .dark
            ? Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.3)
            : Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 0.3)
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
            Arc(angle: angle - del)
                .rotation(del)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: color.clearer(), location: .zero),
                            Gradient.Stop(color: highContrast, location: stop)
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

extension RunningEntryRing {
    private func ArrowHead(size: CGSize) -> some View {
        RightTriangle()
    }
}

