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
    static let BaseSize: CGFloat = 30
    static let BaseStroke: CGFloat = 1.5
    @ScaledMetric(relativeTo: .body) private var ButtonSize: CGFloat = BaseSize
    @ScaledMetric(relativeTo: .body) private var StrokeWeight: CGFloat = BaseStroke
    private var ButtonCircumference: CGFloat { CGFloat(Double.pi) * (ButtonSize - StrokeWeight) }
    
    var body: some View {
        Button(action: discard) {
            ZStack {
                Image(systemName: "xmark")
                Circle()
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: StrokeWeight,
                        lineCap: .round,
                        dash: [ButtonCircumference],
                        /// the 1 + increment starts the circle empty
                        dashPhase: ButtonCircumference * (1 + completion)
                    ))
                    .frame(width: ButtonSize, height: ButtonSize)
                    /// make circle start drawing from 12 'o' clock, not 3 'o' clock
                    .rotationEffect(-.tau / 4)
            }
        }
    }
}
