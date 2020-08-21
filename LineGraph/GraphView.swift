//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// an extremely rough estimate of the usual height `TimeIndicator` will take up,
/// so that it's `widthHelper` has a better estimate of the true `dayHeight`
fileprivate let timeIndicatorHeightEstimate = CGFloat(100)

struct GraphView: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject var model: GraphModel
    
    var body: some View {
        GeometryReader { outer in
            VStack(spacing: .zero) {
                /// 1000 is a meaningless placeholder height
                DateIndicator(dayHeight: outer.size.height * zero.zoomLevel - timeIndicatorHeightEstimate)
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        DayScroll(size: geo.size)
                        GraphButtons()
                    }
                }
                /// allow graph to consume maximum height
                .layoutPriority(1)
            }
        }
    }
    
    func DayScroll(size: CGSize) -> some View {
        let dayHeight = size.height * zero.zoomLevel
        return ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { proxy in
                /// scroll anchor allows view to appear in the right position
                EmptyView()
                    .id(0)
                    .offset(y: size.height)
                HStack(spacing: .zero) {
                    TimeIndicator(divisions: evenDivisions(for: dayHeight))
                    LineGraph(dayHeight: dayHeight)
                }
                    .frame(
                        width: size.width,
                        height: dayHeight * CGFloat(model.days)
                    )
                    .drawingGroup()
                    /// immediately center on white day area
                    .onAppear{ proxy.scrollTo(0, anchor: .center) }
            }
        }
    }
}
