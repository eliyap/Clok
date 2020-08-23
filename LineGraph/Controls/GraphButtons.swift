//
//  GraphButtons.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let buttonPadding = CGFloat(7)

struct GraphButtons: View {
    
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject var model: GraphModel
    @EnvironmentObject var entryLoader: EntryLoader
    
    var body: some View {
        VStack(alignment: .trailing) {
            if entryLoader.state == .loadingBriefly {
                ActivityIndicator()
                    .modifier(ButtonGlyph())
                    .transition(.inAndOut(edge: .top))
            }
            Spacer()
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
        }
        .padding(buttonPadding)
    }
}
