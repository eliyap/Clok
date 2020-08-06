//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    
    /// make a meaningless update to zero Date so it will load data from disk
    func jumpCoreDate() {
        zero.start += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    DayScroll(size: geo.size)
                }
                
            
                HStack {
                    FilterStack()
                        .padding(buttonPadding)
                    Image(systemName: "chevron.left")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= weekLength
                            }
                        }
                    Image(systemName: "chevron.right")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += weekLength
                            }
                        }
                }
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
        .onAppear(perform: jumpCoreDate)
    }
    
    
    func DayScroll(size: CGSize) -> some View {
        let dayHeight = size.height * zero.zoom
        return ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { proxy in
                /// scroll anchor allows view to appear in the right position
                EmptyView()
                    .id(0)
                    .offset(y: size.height)
                HStack(spacing: .zero) {
                    TimeIndicator(divisions: evenDivisions(for: dayHeight))
                    GeometryReader { geo in
                        LineGraph(dayHeight: dayHeight)
                            .frame(width: geo.size.width)
                    }
                }
                .frame(width: size.width, height: dayHeight * 3)
                /// block off part of the extended day strip
                /// keeps focus on the white day area
                .padding([.top, .bottom], -dayHeight / 2)
                .drawingGroup()
                /// immediately center on white day area
                .onAppear{ proxy.scrollTo(0, anchor: .center) }
            }
        }
        /// clip to view height
        .frame(height: size.height)
    }
}

/// prevents the vertical scrollview from over-running the status bar
struct SafetyWrapper<Content: View>:View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(spacing: .zero) {
            /// tiny view stops scroll from drawing above it (into the status bar)
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 1)
            content
        }
    }
}
