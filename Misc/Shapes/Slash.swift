//
//  Slash.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SlashDollar: View {
    
    var billable: Bool
    var strokeWidth: CGFloat = 1.2
    
    /// note: Apple's SF `location.slash` uses this ratio
    static let strokeRatio: CGFloat = 0.75
    
    var color: Color {
        billable ? .primary : .secondary
    }
    
    var body: some View {
        /// ensures image is icon size with aspect ratio 1
        Image(systemName: "circle")
            .foregroundColor(.clear)
            .overlay(Text("$")
                        .font(Font.system(.title3, design: .rounded))
                        .foregroundColor(color)
            )
            .mask(
                /// remove a streak from the image down the middle
                ZStack {
                    /// leaves everything outside the slash untouched
                    Color.white
                    Strike(ratio: 0.7, length: billable ? 0 : 1)
                        .stroke(style: StrokeStyle(
                            lineWidth: strokeWidth * (1 + 2 * Self.strokeRatio),
                            lineCap: .round,
                            lineJoin: .round
                        ))
                }
                    .compositingGroup()
                    .luminanceToAlpha()
            )
            .overlay(
                Strike(ratio: 0.7, length: billable ? 0 : 1)
                    .stroke(style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round,
                        lineJoin: .round
                    ))
                    .foregroundColor(color)
            )
    }
}

struct Strike: InsettableShape {
    
    var insetAmount: CGFloat = .zero
    
    /// how much of the available CGRect to take up. Reducing contracts the slash towards the center
    var ratio: CGFloat = 1
    
    /// how much of the line to draw, from the upper left to lower right
    var length: CGFloat = 1
    
    var animatableData: CGFloat {
        get { length }
        set { length = newValue }
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var line = self
        line.insetAmount += amount
        return line
    }
    
    func path(in rect: CGRect) -> Path {
        guard length > 0 else {
            return Path()
        }
        let start = 0.5 - ratio / 2
        let end = 0.5 + ratio / 2
        return Path { path in
            path.move(to: CGPoint(
                x: rect.width * start,
                y: rect.height * start
            ))
            path.addLine(to: CGPoint(
                x: rect.width * (length * end + (1 - length) * start),
                y: rect.height * (length * end + (1 - length) * start)
            ))
        }
    }
}
