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
    
    @State var items = [UUID(), UUID(), UUID()]
    
    func jumpCoreDate() {
        zero.date += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    InfiniteScroll(geo: geo)
                }
                HStack {
                    FilterStack()
                        .padding(buttonPadding)
                    Image(systemName: "chevron.left.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.date -= dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "chevron.left")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.date -= dayLength
                            }
                        }
                    Image(systemName: "chevron.right")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.date += dayLength
                            }
                        }
                    Image(systemName: "chevron.right.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.date += dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "plus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = min(ZeroDate.countMax, zero.dayCount + 1)
                            }
                        }
                    Image(systemName: "minus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = max(ZeroDate.countMin, zero.dayCount - 1)
                            }
                        }
                }
                
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
        .onAppear(perform: jumpCoreDate)
    }
    
    func InfiniteScroll(geo: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: .zero) {
                ForEach(Array(items.enumerated()), id: \.1) { idx, item in
                    LineGraph(
                        offset: idx,
                        size: geo.size
                    )
                    .frame(width: geo.size.width, height: geo.size.height)
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: geo.size.width, height: 2)
                }
            }
            .padding([.top, .bottom], -geo.size.height / 2)
        }
    }
    
    func frameHeight(geo: GeometryProxy) -> CGFloat {
        geo.size.height * CGFloat(dayLength / zero.interval)
    }
}


