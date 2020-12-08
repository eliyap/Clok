//
//  AlignedTimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/**
 In lieu of properly designing a `TimeIndicator` to handle arbitrary offsets,
 I just glued together some existing `TimeIndicator`s and let the unused parts clip out of bounds
 */
struct AlignedTimeIndicator: View {
    
    let height: CGFloat
    
    /** The `y` position of the scroll, which determines what time interval is shown.
        Bounded between [0, 1]
     */
    let rowY: CGFloat
    
    var body: some View {
        VStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
        }
            .frame(height: height)
            .offset(y: -height * rowY)
    }
}
