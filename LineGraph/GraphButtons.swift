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
        ZStack {
            BackButton
                .offset(x: -GraphButton.size)
            FwrdButton
                .offset(x: +GraphButton.size)
            ZoomInButton
                .offset(y: -GraphButton.size)
            ZoomOutButton
                .offset(y: +GraphButton.size)
            
        }
        .offset(
            x: +GraphButton.size,
            y: -GraphButton.size
        )
        .padding(buttonPadding)
            

    }
    var thing: some View {
        Image(systemName: "star")
            .modifier(ButtonGlyph())
            .onTapGesture {
                withAnimation(.linear(duration: 0.4)) {
                    model.mode.toggle()
                }
            }
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
        Image(systemName: "plus.magnifyingglass")
            .modifier(ButtonGlyph())
            .onTapGesture {
                withAnimation {
                    zero.interval = max(
                        zero.interval - .hour,
                        .hour
                    )
                }
            }
    }
    
    private var ZoomOutButton: some View {
        Image(systemName: "minus.magnifyingglass")
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
}
