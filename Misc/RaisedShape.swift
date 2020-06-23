//
//  RaisedShape.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.22.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/**
 simulate a raised shape by adding shadows
 with thanks to https://swiftwithmajid.com/2019/12/18/the-power-of-viewbuilder-in-swiftui/
 */
struct RaisedShape<Content: Shape>: View {
    let content: Content
    let radius: CGFloat
    init(radius r: CGFloat, @ViewBuilder c: () -> Content) {
        radius = r
        content = c()
    }

    var body: some View {
        content
            .fill(Color(UIColor.systemBackground))
            .shadow(
                color: Color(UIColor.black).opacity(0.2),
                radius: radius,
                x: radius,
                y: radius
            )
            .shadow(
                color: Color(UIColor.white).opacity(0.1),
                radius: radius,
                x: -radius / 2,
                y: -radius / 2
            )
    }
}
