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
                    VStack(spacing: .zero) {
                        HStack(spacing: .zero) {
                            /// token time indicator keeps the margins consistent
                            TimeIndicator(divisions: 1, days: 1)
                                .layoutPriority(1)
                                .opacity(0)
                            ForEach(0..<zero.dayCount, id: \.self) {
                                Divider()
                                Text("\($0)")
                                    .frame(maxWidth: .infinity)
                            }
                        
                        }
                        DayScroll(size: geo.size)
                            .layoutPriority(1)
                    }
                    
                }
                
            
                HStack {
                    FilterStack()
                        .padding(buttonPadding)
                    Image(systemName: "chevron.left.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "chevron.left")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= dayLength
                            }
                        }
                    Image(systemName: "chevron.right")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += dayLength
                            }
                        }
                    Image(systemName: "chevron.right.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "plus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = min(zero.countMax, zero.dayCount + 1)
                            }
                        }
                    Image(systemName: "minus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = max(zero.countMin, zero.dayCount - 1)
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
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                /// scroll anchor allows view to appear in the right position
                EmptyView()
                    .id(0)
                    .offset(y: size.height)
                LineGraph(size: size)
                    .frame(width: size.width, height: size.height * 3)
                    .padding([.top, .bottom], -size.height / 2)
                    .onAppear{ proxy.scrollTo(0, anchor: .center) }
            }
        }
    }
}
