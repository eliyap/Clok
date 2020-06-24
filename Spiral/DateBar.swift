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

struct weekButtonStyle : ViewModifier {
    let radius = CGFloat(10)
    func body(content: Content) -> some View {
        content
            .padding()
            .background(RaisedShape(radius: radius) { Circle() })
            .padding()
    }
}

/// click to roll back to the previous week
struct prevWeekButton : View {
    @EnvironmentObject private var zero:ZeroDate
    
    var body : some View {
        /// logic for "previous" week
        Button(action: {
            withAnimation { self.zero.date -= weekLength }
            self.zero.weekSkip = .back
        }) {
            Image(systemName: "chevron.left")
                .font(.subheadline)
                .foregroundColor(.primary)
                .modifier(weekButtonStyle())
        }
    }
}

/// click to roll forwards to the next week
struct nextWeekButton : View {
    @EnvironmentObject private var zero:ZeroDate
    
    var body : some View {
        /// logic for "next" week
        Button(action: {
            withAnimation { self.zero.date += weekLength }
            self.zero.weekSkip = .fwrd
        }) {
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .foregroundColor(.primary)
                .modifier(weekButtonStyle())
        }
    }
}
