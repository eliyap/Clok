//
//  DiscardButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DiscardButton: View {
    
    let discard: () -> Void
    /// measures the progress of the "swipe down to dismiss" gesture. bounded from [0, 1]
    var completion: CGFloat
    
    /// visual parameters
    static let ButtonSize: CGFloat = 30
    static let ButtonStrokeWeight: CGFloat = 1.5
    static var ButtonCircumference: CGFloat { CGFloat(Double.pi) * (Self.ButtonSize - ButtonStrokeWeight) }
    
    var body: some View {
        Button(action: discard) {
            ZStack {
                Image(systemName: "xmark")
                Circle()
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: Self.ButtonStrokeWeight,
                        lineCap: .round,
                        dash: [Self.ButtonCircumference],
                        /// the 1 + increment starts the circle empty
                        dashPhase: Self.ButtonCircumference * (1 + completion)
                    ))
                    .frame(width: Self.ButtonSize, height: Self.ButtonSize)
                    /// make circle start drawing from 12 'o' clock, not 3 'o' clock
                    .rotationEffect(-.tau / 4)
            }
        }
    }
}
