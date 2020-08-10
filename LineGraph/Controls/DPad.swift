//
//  DPad.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 9/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DPad: View {
    
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject var model: GraphModel
    
    var body: some View {
        ZStack(alignment: .center) {
            GraphButton(glyph: "chevron.left") {
                zero.dateChange = .back
                withAnimation {
                    zero.start -= .week
                }
            }
                .offset(x: -GraphButton.size)
            GraphButton(glyph: "chevron.right") {
                zero.dateChange = .fwrd
                withAnimation {
                    zero.start += .week
                }
            }
                .offset(x: +GraphButton.size)
            
            /// zoom in button
            GraphButton(
                glyph: "plus.magnifyingglass",
                condition: zero.interval > .hour
            ) {
                withAnimation {
                    zero.interval -= .hour
                }
            }
                .offset(y: -GraphButton.size)
            
            /// zoom out button
            GraphButton(
                glyph: "minus.magnifyingglass",
                condition: zero.interval < .day
            ) {
                zero.dateChange = .back
                withAnimation {
                    zero.interval += .hour
                }
            }
                .offset(y: +GraphButton.size)
            
        }
        .frame(
            width: 3 * GraphButton.size,
            height: 3 * GraphButton.size
        )
    }
}
