//
//  RunningSquare.swift
//  RunningRingExtension
//
//  Created by Secret Asian Man Dev on 20/10/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct RunningSquare: View {
    
    var entry: Provider.Entry
    
    @Environment(\.colorScheme) var mode
    
    let strokeWidth = CGFloat(7)
    
    var body: some View {
        ZStack {
            switch (entry.entry, hours) {
            case (.noEntry, _):
                EmptyRing
            default:
                EmptyRing
                HourArc
                ContainerRelativeShape()
                    .inset(by: strokeWidth * 2)
                    .fill(angleGradient(start: color, end: color))
                    .opacity(0.2)
                    .rotationEffect(-.tau / 4)
            }
            VStack(alignment: .leading) {
                Text(entry.entry.description)
                    .font(.headline)
                    /// allow for something as long as `Troublemaker General`, but don't allow it to overwhelm the widget
                    .lineLimit(2)
                Text(entry.entry.project.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(highContrast)
                Spacer()
                TimeIndicator
            }
            .padding(strokeWidth * 2.5)
        }
    }
}

// MARK: - Computed Vars
extension RunningSquare {
    
    var color: Color { entry.entry.project.wrappedColor }
    var duration: TimeInterval { entry.date - entry.entry.start }
    /// the angle to rotate the ring
    var angle: Angle {
        Angle(radians: .tau * duration.mod(.hour) / .hour)
    }
    var stop: CGFloat { CGFloat(angle.radians / .tau) }
    /// the number of complete hours to be displayed
    var hours: Int {
        Int(duration / .hour)
    }
    
    func angleGradient(start: Color, end: Color) -> AngularGradient {
        AngularGradient(
            gradient: Gradient(stops: [
                Gradient.Stop(color: .clear, location: .zero),
                Gradient.Stop(color: start, location: 0.001),
                Gradient.Stop(color: end, location: stop),
                Gradient.Stop(color: .clear, location: stop + 0.001),
                Gradient.Stop(color: .clear, location: 1)
            ]),
            center: .center
        )
    }
}

// MARK: - Adjusted Colors
extension RunningSquare {
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
}

// MARK: - Time Indicator
extension RunningSquare {
    /// shows the amount of time spent on this project
    private var TimeIndicator: some View {
        Time
            .font(.system(size: 16, design: .rounded))
            .bold()
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

// MARK: - Under 1 Hour
extension RunningSquare {
    private var HourArc: some View {
        ContainerRelativeShape()
            .inset(by: strokeWidth)
            .strokeBorder(
                angleGradient(start: darker, end: lighter),
                style: StrokeStyle(lineWidth: strokeWidth))
            .rotationEffect(.tau * -0.25)
    }
    
    private var EmptyRing: some View {
        ContainerRelativeShape()
            .inset(by: strokeWidth)
            .strokeBorder(Color(UIColor.systemGray6), style: StrokeStyle(lineWidth: strokeWidth))
    }
}

// MARK: - Over 1 Hour
extension RunningSquare {
    private var MultiHourRing: some View {
        ContainerRelativeShape()
            .inset(by: strokeWidth)
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(stops: [
//                        Gradient.Stop(color: .clear, location: .zero),
//                        Gradient.Stop(color: darker, location: 0.001),
                        Gradient.Stop(color: lighter, location: stop),
                        Gradient.Stop(color: darker, location: stop + 0.001),
//                        Gradient.Stop(color: .clear, location: 1)
                    ]),
                    center: .center
                ),
                style: StrokeStyle(lineWidth: strokeWidth))
            .rotationEffect(.tau * -0.25)
    }
}
