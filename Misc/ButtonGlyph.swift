//
//  WeekButtonGlyph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// though hard coded size is undesirable
// this was the only way I could think of to enforce width
let glyphFrameSize = CGFloat(10)
let backgroundPadding = CGFloat(15)

struct ButtonGlyph : ViewModifier {
    let radius = CGFloat(10)
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: glyphFrameSize * 2))
            // enforce square images so that SF symbols align vertically
            .frame(width: glyphFrameSize, height: glyphFrameSize)
            // adapts to dark mode
            .foregroundColor(.primary)
            .padding(backgroundPadding)
            .background(RaisedShape(radius: radius) { Circle() })
    }
}
