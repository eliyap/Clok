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
        HStack(alignment: .bottom) {
            DPad()
            Spacer()
            GraphButton(glyph: model.mode == .calendar
                ? "calendar"
                : "chart.bar.fill"
            ) {
                withAnimation(.linear(duration: 0.4)) {
                    model.mode.toggle()
                }
            }
        
        }
        .padding(buttonPadding)
    }
}
