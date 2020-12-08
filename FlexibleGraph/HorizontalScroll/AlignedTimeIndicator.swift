//
//  AlignedTimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct AlignedTimeIndicator: View {
    
    let height: CGFloat
    
    /** The `y` position of the scroll, which determines what time interval is shown.
        Bounded between [0, 1]
     */
    let rowY: CGFloat
    
    /// Glues together 2 `TimeIndicators` in the right way to place it in beside the `HorizontalScrollView`
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
