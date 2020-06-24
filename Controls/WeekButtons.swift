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
    
    var body: some View {
        Image(systemName: name)
            .font(.subheadline)
            .foregroundColor(.primary)
            .padding()
            .background(RaisedShape(radius: radius) { Circle() })
            .padding()
    }
}


struct weekButtonStyle : ViewModifier {
    let radius = CGFloat(10)
    func body(content: Content) -> some View {
        content
            .padding()
            .background(RaisedShape(radius: radius) { Circle() })
            .padding()
    }
}

struct WeekButtons: View {
    @EnvironmentObject private var zero:ZeroDate

    var body: some View {
        HStack {
            Button(action: {
                withAnimation { self.zero.date -= weekLength }
                self.zero.weekSkip = .back
            }) { WeekButtonGlyph(name: "chevron.left") }
            Spacer()
            Button(action: {
                withAnimation { self.zero.date += weekLength }
                self.zero.weekSkip = .fwrd
            }) { WeekButtonGlyph(name: "chevron.right") }
        }
    }
}
