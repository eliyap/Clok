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
        HStack(alignment: .center, spacing: .zero) {
            BackButton
            VStack(spacing: .zero) {
                ZoomInButton
                InvisibleButton
                ZoomOutButton
            }
            FwrdButton
            Image(systemName: "star")
                .modifier(ButtonGlyph())
                .onTapGesture {
                    withAnimation(.linear(duration: 0.4)) {
                        model.mode.toggle()
                    }
                }
        }
        .padding(buttonPadding)
    }
    
    private var BackButton: some View {
        Image(systemName: "chevron.left")
            .modifier(ButtonGlyph())
            .onTapGesture {
                zero.dateChange = .back
                withAnimation {
                    zero.start -= .week
                }
            }
    }
    
    private var FwrdButton: some View {
        Image(systemName: "chevron.right")
            .modifier(ButtonGlyph())
            .onTapGesture {
                zero.dateChange = .fwrd
                withAnimation {
                    zero.start += .week
                }
            }
    }
    
    private var ZoomInButton: some View {
        Image(systemName: "arrow.up.left.and.arrow.down.right")
            .modifier(ButtonGlyph())
            .onTapGesture {
                zero.interval = max(
                    zero.interval - .hour,
                    .hour
                )
            }
    }
    
    private var ZoomOutButton: some View {
        Image(systemName: "arrow.down.right.and.arrow.up.left")
            .modifier(ButtonGlyph())
            .onTapGesture {
                withAnimation {
                    zero.interval = min(
                        zero.interval + .hour,
                        .day
                    )
                }
            }
    }
    
    private var InvisibleButton: some View {
        EmptyView()
            .modifier(ButtonGlyph())
            .opacity(.zero)
            .allowsHitTesting(false)
    }
}
