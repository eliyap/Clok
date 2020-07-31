//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let itemCount = 3

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    
    
    @State var items: [UUID] = stride(from: 0, to: itemCount, by: 1).map{_ in UUID()}
    @State var meaningless = false
    
    let threshhold = CGFloat(0.25)
    
    func jumpCoreDate() {
        zero.date += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    if meaningless {
                        InfiniteScroll(geo: geo)
                    } else {
                        InfiniteScroll(geo: geo)
                    }
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
        ScrollView {
            ScrollViewReader { proxy in
                GeometryReader { topGeo in
                    Run {
                        guard geo.frame(in: .global).minY - topGeo.frame(in: .global).minY < -geo.size.height * threshhold else { return }
                        meaningless.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation{
                                popUp()
                                zero.date -= dayLength
                            }
                        }
                    }
                }
                VStack(spacing: .zero) {
                    ForEach(Array(items.enumerated()), id: \.1) { idx, item in
                        LineGraph(
                            offset: idx,
                            size: geo.size
                        )
                        .frame(width: geo.size.width, height: geo.size.height)
                        Controller()
                            .foregroundColor(.red)
                            .frame(width: geo.size.width, height: 40)
                    }
                }
                .onAppear {
                    withAnimation {
                        proxy.scrollTo(items[1])
                    }
                }
                .padding([.top, .bottom], -geo.size.height / 2)
                GeometryReader { botGeo in
                    Run {
                        guard botGeo.frame(in: .global).maxY - geo.frame(in: .global).maxY < -geo.size.height * threshhold else { return }
                        meaningless.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation {
                                popDown()
                                zero.date += dayLength
                            }
                        }
                    }
                }
            }
        }
            
        
    }
    
    func frameHeight(geo: GeometryProxy) -> CGFloat {
        geo.size.height * CGFloat(dayLength / zero.interval)
    }
    
    func popUp() -> Void {
        items.insert(UUID(), at: 0)
        items.removeLast()
    }
    
    func popDown() -> Void {
        items.append(UUID())
        items.removeFirst()
    }
}


