//
//  NewLinedBackground.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct NewLinedBackground: View {
    let divisions: Int
    
    var body: some View {
        VStack(spacing: .zero) {
            ForEach(
                Array(stride(
                    from: 0,
                    to: .day,
                    by: .day / Double(divisions)
                )), id: \.self) {
                    Slice(interval: $0)
            }
        }
    }
    
    /// Draw 1 line in the background at the given time interval offset
    private func Slice(interval: TimeInterval) -> some View {
        Group {
            if interval.remainder(dividingBy: .day) == 0 {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.red) /// midnight divider is red
            } else {
                Divider()
            }
            if interval < 0 || interval >= .day { /// outside the highlighted 1 day range
                Rectangle().foregroundColor(.clokBG)
            } else {
                Rectangle().foregroundColor(.background)
            }
        }
    }
}
