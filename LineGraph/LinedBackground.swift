//
//  LinedBackground.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LinedBackground: View {
    let height: CGFloat
    @EnvironmentObject var model: GraphModel
    var body: some View {
        VStack(spacing: .zero) {
            ForEach(
                Array(stride(
                    from: -model.castBack,
                    to: model.castFwrd,
                    by: dayLength / Double(evenDivisions(for: height))
                )), id: \.self) {
                    Slice(interval: $0)
            }
        }
    }
    
    private func Slice(interval: TimeInterval) -> some View {
        Group {
            if interval.remainder(dividingBy: dayLength) == 0 {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.red) /// midnight divider is red
            } else {
                Divider()
            }
            if interval < 0 || interval >= dayLength { /// outside the highlighted 1 day range
                Rectangle().foregroundColor(.clokBG)
            } else {
                Rectangle().foregroundColor(Color(UIColor.systemBackground))
            }
        }
    }
}
