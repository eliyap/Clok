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
        HStack {
            Image(systemName: "chevron.left")
                .modifier(ButtonGlyph())
                .onTapGesture {
                    zero.dateChange = .back
                    withAnimation {
                        zero.start -= weekLength
                    }
                }
            Image(systemName: "chevron.right")
                .modifier(ButtonGlyph())
                .onTapGesture {
                    zero.dateChange = .fwrd
                    withAnimation {
                        zero.start += weekLength
                    }
                }
            Image(systemName: "star")
                .modifier(ButtonGlyph())
                .onTapGesture {
                    withAnimation(.linear(duration: 0.4)) {
                        model.mode.toggle()
                    }
                }
        }
        .padding(buttonPadding)
    }
}
