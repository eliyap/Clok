//
//  FilterButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FilterButton: View {
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var settings: Settings
    
    let radius = CGFloat(10)
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.data.searching.toggle()
            }
        }) {
            WeekButtonGlyph(
                /// fill icon when searching
                name: "line.horizontal.3.decrease.circle" + (self.data.searching ? ".fill" : "")
            )
        }
        .disabled(settings.tab == .settings)
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton()
    }
}
