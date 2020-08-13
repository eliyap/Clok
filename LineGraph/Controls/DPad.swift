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
                condition: zero.zoomIdx < zero.zoomLevels.count - 1
            ){
                withAnimation {
                    zero.zoomIdx += 1
                }
            }
                .offset(y: -GraphButton.size)
            
            /// zoom out button
            GraphButton(
                glyph: "minus.magnifyingglass",
                condition: zero.zoomIdx > 0
            ){
                withAnimation {
                    zero.zoomIdx -= 1
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
