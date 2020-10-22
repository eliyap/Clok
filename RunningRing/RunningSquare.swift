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
                    .opacity(Double(adjustedOpacity))
                    .rotationEffect(-.tau / 4)
                HourDots(count: hours)
            }
            VStack(alignment: .leading) {
                Text(entry.entry.entryDescription)
                    .font(.headline)
                    /// allow for something as long as `Troublemaker General`, but don't allow it to overwhelm the widget
                    .lineLimit(1)
                Spacer()
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        ProjectLabel
                        TimeIndicator
                    }
                    Spacer()
                    Image(systemName: "arrow.counterclockwise")
                        .font(Font.system(size: 16).weight(.semibold))
                        /// not inset properly for some reason
                        .padding(strokeWidth / 2)
                        .opacity(0.5)
                }
            }
                .padding(strokeWidth * 2.5)
        }
    }
    
    func HourDots(count: Int) -> some View {
        let dotDiameter = CGFloat(6)
        
        func dot(_ color: Color) -> some View {
            return Circle()
                .frame(width: dotDiameter, height: dotDiameter)
                .foregroundColor(color)
        }
        
        func dotRing() -> some View {
            let radius: CGFloat = dotDiameter * CGFloat(count) / CGFloat.pi
            return ForEach(0..<count, id: \.self) { idx in
                dot(color)
                    .offset(x: radius)
                    .rotationEffect(.tau * Double(idx) / Double(count))
            }
            .rotationEffect(.tau * -0.25)
            .rotationEffect(count.isMultiple(of: 2)
                ? Angle(radians: .pi / Double(count))
                : .zero
            )
        }
        
        /// (ab)use `Group` to erase type
        return Group {
            switch count {
            case let x where x <= 0:
                dot(Color(UIColor.systemGray6))
            case 1:
                dot(color)
            case 2:
                HStack(spacing: .zero) {
                    dot(color)
                    dot(.clear)
                    dot(color)
                }
            default:
                dotRing()
            }
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
    
    /**
     adjusts base opacity based on a few factors
     - saturation: more saturated colors are adjusted more
     - brightness: brighter colors are adjusted less
     - mode: dark mode is more translucent, light mode is more opaque
     */
    var adjustedOpacity: CGFloat {
        let darkness: CGFloat = (1+color.saturation)*(1-color.brightness)
        let adjustment = mode == .dark
            ? +0.4 * darkness
            : -0.25 * darkness
        return 0.2 * (1 + adjustment)
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

// MARK: - Text Bits
extension RunningSquare {
    
    private var ProjectLabel: some View {
        Text(entry.entry == .noEntry
             ? ""
             : entry.entry.project.name
        )
            .font(.subheadline)
            .bold()
            .lineLimit(1)
            .foregroundColor(highContrast)
    }
    
    /// shows the amount of time spent on this project
    private var TimeIndicator: some View {
        Time
            .font(.system(size: 16, design: .rounded))
            .bold()
    }
    
    private var Time: Text {
        switch entry.entry {
        case .noEntry:
            return Text("00:00")
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
