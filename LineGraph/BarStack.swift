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
    @State var ids = Array(stride(from: 0, to: 5, by: 1)) /// swiftui does not like negative indices
    @State var hitTest = true
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    ScrollView(.vertical, showsIndicators: false) {
                        ScrollViewReader { proxy in
                            TopReader(geo: geo, proxy: proxy)
                            VStack(spacing: .zero) {
                                ForEach(ids, id: \.self){
                                    LineGraph(offset: $0 - 2) /// keep 0 the middle
                                        .frame(width: geo.size.width, height: geo.size.height)
                                    Rectangle()
                                        .foregroundColor(.red)
                                        .frame(width: geo.size.width, height: 2)
                                }                            
                            }
                            BottomReader(geo: geo, proxy: proxy)
                        }
                    }
                }
                .allowsHitTesting(hitTest)
                FilterStack()
                    .padding(buttonPadding)
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
    }
    
    
    func TopReader(geo: GeometryProxy, proxy: ScrollViewProxy) -> some View {
        GeometryReader { topGeo in
            Run {
                guard (geo.frame(in: .global).minY - topGeo.frame(in: .global).minY < geo.size.height) else { return }
                proxy.scrollTo(2)
                hitTest = false
                DispatchQueue.main.async {
                    hitTest = true
                }
                zero.date -= dayLength
            }
        }
        .frame(width: .zero, height: .zero)
    }
    func BottomReader(geo: GeometryProxy, proxy: ScrollViewProxy) -> some View {
        GeometryReader { botGeo in
            Run {
                guard (botGeo.frame(in: .global).maxY - geo.frame(in: .global).maxY < geo.size.height) else { return }
                proxy.scrollTo(2)
                hitTest = false
                DispatchQueue.main.async {
                    hitTest = true
                }
                zero.date += dayLength
            }
        }
    }
}

struct Run: View {
    let block: () -> Void

    var body: some View {
        DispatchQueue.main.async(execute: block)
        return AnyView(EmptyView())
    }
}

