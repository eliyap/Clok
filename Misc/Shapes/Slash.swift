//
//  Slash.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct Slash: View {
    
    /// note: Apple's SF `location.slash` uses this ratio
    static let strokeRatio: CGFloat = 0.75
    
    var strokeWidth: CGFloat = 1.2
    var length: CGFloat = 1
    var foregroundColor: Color
    var backgroundColor: Color
    
    var body: some View {
        ZStack {
            Strike(strokeWidth: strokeWidth * (1 + Self.strokeRatio), length: length)
                .strokeBorder(style: StrokeStyle(
                    lineWidth: strokeWidth * Self.strokeRatio,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .foregroundColor(backgroundColor)
            Strike(strokeWidth: strokeWidth, length: length)
                .foregroundColor(foregroundColor)
        }
    }
}

struct Strike: InsettableShape {
    
    var insetAmount: CGFloat = .zero
    var strokeWidth: CGFloat = .zero
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
        
        return Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(
                x: rect.width * length,
                y: rect.height * length
            ))
        }
        .strokedPath(StrokeStyle(
            lineWidth: strokeWidth,
            lineCap: .round,
            lineJoin: .round
        ))
    }
}
