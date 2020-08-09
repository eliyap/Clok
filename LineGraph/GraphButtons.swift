//
//  GraphButtons.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct GraphButtons: View {
    
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject var model: GraphModel
    
    var body: some View {
        ZStack {
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
            GraphButton(glyph: "plus.magnifyingglass", condition: zero.interval > .hour) {
                withAnimation {
                    zero.interval -= .hour
                }
            }
                .offset(y: -GraphButton.size)
            GraphButton(glyph: "minus.magnifyingglass", condition: zero.interval < .day) {
                zero.dateChange = .back
                withAnimation {
                    zero.interval += .hour
                }
            }
                .offset(y: +GraphButton.size)
            
        }
        .offset(
            x: +GraphButton.size,
            y: -GraphButton.size
        )
        .padding(buttonPadding)
            

    }
    var thing: some View {
        Image(systemName: "star")
            .modifier(ButtonGlyph())
            .onTapGesture {
                withAnimation(.linear(duration: 0.4)) {
                    model.mode.toggle()
                }
            }
    }
}
