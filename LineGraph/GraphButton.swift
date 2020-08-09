//
//  GraphButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 9/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// though hard coded size is undesirable
// this was the only way I could think of to enforce width
fileprivate let glyphFrameSize = CGFloat(10)
fileprivate let backgroundPadding = CGFloat(15)
fileprivate let radius = CGFloat(10)

struct GraphButton: View {
    
    @State var scale: CGFloat = 1
    
    let glyph: String
    var condition: Bool = true
    let action: () -> ()
    
    var body: some View {
        Button {
            if condition {
                action()
                animateSuccess()
            } else {
                animateFailure()
            }
            
        } label: {
            Image(systemName: glyph)
                .font(.system(size: glyphFrameSize * 2))
                // enforce square images so that SF symbols align vertically
                .frame(width: glyphFrameSize, height: glyphFrameSize)
                .foregroundColor(.primary) /// adapts to dark mode
                .padding(backgroundPadding)
                .background(RaisedShape(radius: radius) { Circle() })
        }
        .scaleEffect(scale)
    }
    
    static let size = glyphFrameSize + backgroundPadding * 2
    private func animateSuccess() -> Void {
        withAnimation(.linear(duration: 0.25)) { scale = 1.25 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring()) {
                scale = 1
            }
        }
    }
    
    private func animateFailure() -> Void {
        withAnimation(.linear(duration: 0.25)) { scale = 0.25 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring()) {
                scale = 1
            }
        }
    }
}
