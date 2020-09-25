//
//  ShadowArcView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ShadowArcView: View {
    
    let color: Color
    let angle: Angle
    let hours: Int
    
    let ratio = CGFloat(0.6)
    var coratio: CGFloat {
        (1 - ratio) * 0.5
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                /// colors the ring
                Circle()
                    .foregroundColor(color)
                /// adds the shadow
                Circle()
                    .frame(
                        width: geo.size.width * coratio,
                        height: geo.size.height * coratio
                    )
                    .foregroundColor(color)
                    .offset(x: geo.size.width * (ratio + coratio) * 0.5)
                    .rotationEffect(angle)
                    .shadow(
                        color: .primary,
                        radius: 2
                    )
                /// cuts off the trailing half of the shadow
                SemiCircle()
                    .foregroundColor(color)
                    .rotationEffect(angle)
                /// cuts off the inner shadow bleed
                /// and makes the circle a donut
                Circle()
                    .frame(
                        width: geo.size.width * ratio,
                        height: geo.size.height * ratio
                    )
                    .foregroundColor(Color(UIColor.systemBackground))
                Text("\(hours)")
                    .foregroundColor(color)
            }
            /// cuts off the outer shadow bleed
            .clipShape(Circle())
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .frame(maxWidth: 80, maxHeight: 80)
    }
}

