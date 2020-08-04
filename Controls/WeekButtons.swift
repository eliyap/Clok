//
//  DateBar.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.24.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

enum weekLabels : String {
    case current = "This Week"
    case pastSeven = "Last 7 Days"
    case last = "Last Week"
    case next = "Next"
    case prev = "Prev"
}

struct WeekButtons: View {
    @EnvironmentObject private var zero:ZeroDate
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var settings: Settings
    
    var body: some View {
        HStack {
            Button {
                /// break out of search if tapped
                guard !self.data.searching else {
                    withAnimation { self.data.searching = false }
                    return
                }
                
                zero.dateChange = .back
                withAnimation { zero.start -= weekLength }
            } label: {
                WeekButtonGlyph(name: "chevron.left")
                    .padding(buttonPadding)
            }
            
            Spacer()
            Button {
                /// break out of search if tapped
                guard !self.data.searching else {
                    withAnimation { self.data.searching = false }
                    return
                }
                
                zero.dateChange = .fwrd
                withAnimation { zero.start += weekLength }
            } label: {
                WeekButtonGlyph(name: "chevron.right")
                    .padding(buttonPadding)
            }
        }
        .disabled(settings.tab == .settings)
    }
}
