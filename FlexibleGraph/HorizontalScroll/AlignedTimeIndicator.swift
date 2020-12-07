//
//  AlignedTimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    /// Glues together 2 `TimeIndicators` in the right way to place it in beside the `HorizontalScrollView`
    func AlignedTimeIndicator(height: CGFloat) -> some View {
        VStack(spacing: .zero) {
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
            NewTimeIndicator(divisions: evenDivisions(for: height))
                .frame(height: height)
        }
            .frame(height: height, alignment: .top)
            .offset(y: -height * rowPosition.position.y)
    }
}
