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

struct WeekButtonGlyph: View {
    let name: String
    let radius = CGFloat(10)
    
    // though hard coded size is undesirable
    // this was the only way I could think of to enforce width
    let size = CGFloat(10)
    
    var body: some View {
        Image(systemName: name)
            .font(.system(size: size * 2))
            // enforce square images so that SF symbols align vertically
            .frame(width: size, height: size)
            // adapts to dark mode
            .foregroundColor(.primary)
            .padding()
            .background(RaisedShape(radius: radius) { Circle() })
    }
}

struct WeekButtons: View {
    @EnvironmentObject private var zero:ZeroDate
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation { self.zero.date -= weekLength }
                self.zero.weekSkip = .back
            }) {
                WeekButtonGlyph(name: "chevron.left")
                    .padding(buttonPadding)
            }
            Spacer()
            Button(action: {
                withAnimation { self.zero.date += weekLength }
                self.zero.weekSkip = .fwrd
            }) {
                WeekButtonGlyph(name: "chevron.right")
                    .padding(buttonPadding)
            }
        }
    }
}
