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
                    Image(systemName: "plus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.interval += 3600
//                                zero.dayCount = min(zero.countMax, zero.dayCount + 1)
                            }
                        }
                    Image(systemName: "minus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.interval -= 3600
//                                zero.dayCount = max(zero.countMin, zero.dayCount - 1)
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
        return SafetyWrapper {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                   /// scroll anchor allows view to appear in the right position
                    EmptyView()
                       .id(0)
                       .offset(y: size.height)
                    HStack(spacing: .zero) {
                        TimeIndicator(divisions: evenDivisions(for: dayHeight))
                            .background(Color.clokBG)
                            /// sticky this to the left edge
//                                .offset(x: bounds.insets.leading - geo.frame(in: .global).minX)
                        GeometryReader { geo in
                            TabView {
                                LineGraph(dayHeight: dayHeight)
                                    .frame(width: geo.size.width)
                                LineGraph(dayHeight: dayHeight)
                                    .frame(width: geo.size.width)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                    }
                    
                    .frame(width: size.width, height: dayHeight * 3)
                    /// block off part of the extended day strip
                    /// keeps focus on the white day area
                    .padding([.top, .bottom], -dayHeight / 2)
                
                    /// immediately center on white day area
                    .onAppear{ proxy.scrollTo(0, anchor: .center) }
                   
                }
            }
        }
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
