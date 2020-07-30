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
    
    func enumDays() -> [(Int, Date)] {
        stride(from: 0, to: 5, by: 1).map{
            ($0, Calendar.current.startOfDay(for: zero.date) + Double($0) * dayLength)
        }
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
    }
    
    func InfiniteScroll(geo: GeometryProxy) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { proxy in
                TopReader(geo: geo, proxy: proxy)
                VStack(spacing: .zero) {
                    ForEach(
                        enumDays(),
                        id: \.1.timeIntervalSince1970
                    ){ idx, date in
                        LineGraph(date: date)
                            .frame(width: geo.size.width, height: frameHeight(geo: geo))
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: geo.size.width, height: 2)
                    }
                }
                BottomReader(geo: geo, proxy: proxy)
            }
        }
    }
    
    /// the time interval of the middle row (target to scroll to)
    var middleRow: TimeInterval {
        (Calendar.current.startOfDay(for: zero.date) + 2 * dayLength).timeIntervalSince1970
    }
    
    /// how tall a day should be. Scaled against time interval shown on screen
    func frameHeight(geo: GeometryProxy) -> CGFloat {
        geo.size.height * CGFloat(dayLength / zero.interval)
    }
    
    func TopReader(geo: GeometryProxy, proxy: ScrollViewProxy) -> some View {
        GeometryReader { topGeo in
            Run {
                guard (geo.frame(in: .global).minY - topGeo.frame(in: .global).minY < frameHeight(geo: geo)) else { return }
                proxy.scrollTo(middleRow, anchor: .top)
                zero.date -= dayLength
            }
        }
        .frame(width: .zero, height: .zero)
    }
    
    func BottomReader(geo: GeometryProxy, proxy: ScrollViewProxy) -> some View {
        GeometryReader { botGeo in
            Run {
                guard (botGeo.frame(in: .global).maxY - geo.frame(in: .global).maxY < frameHeight(geo: geo)) else { return }
                proxy.scrollTo(middleRow, anchor: .bottom)
                zero.date += dayLength
            }
        }
    }
}
