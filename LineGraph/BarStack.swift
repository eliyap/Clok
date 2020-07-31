//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let itemCount = 4

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    
    
    @State var items: [UUID] = stride(from: 0, to: itemCount, by: 1).map{_ in UUID()}
    
    @State var offset = CGFloat.zero
    @State var handler = DragHandler()
    
    func jumpCoreDate() {
        zero.date += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    InfiniteScroll(geo: geo)
                }
                FilterStack()
                    .padding(buttonPadding)
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
        .onAppear() {
            jumpCoreDate()
        }
    }
    
    func InfiniteScroll(geo: GeometryProxy) -> some View {
        VStack(spacing: .zero) {
            ForEach(Array(items.enumerated()), id: \.1) { idx, item in
                LineGraph(offset: idx)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .opacity((idx == 0 || idx == 3) ? 0.5 : 1)
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: geo.size.width, height: 2)
            }
        }
        .padding([.top, .bottom], -geo.size.height)
        .offset(y: offset)
        .gesture(DragGesture()
            .onChanged {value in
                withAnimation {
                    handler.update(value: value, height: geo.size.height, offset: $offset, popUp: popUp, popDown: popDown)
                }
            }
            .onEnded { value in
                handler.lastUpdate(value: value, height: geo.size.height, offset: $offset)
            }
        )
    }
    
    func frameHeight(geo: GeometryProxy) -> CGFloat {
        geo.size.height * CGFloat(dayLength / zero.interval)
    }
    
    func popUp() -> Void {
        withAnimation {
            items.insert(UUID(), at: 0)
            items.removeLast()
        }
    }
    
    func popDown() -> Void {
        withAnimation {
            items.append(UUID())
            items.removeFirst()
        }
    }
}


