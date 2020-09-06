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

/// the name of the custom frame used to place the graph's position
fileprivate let ScrollFrameName = "ScrollFrame"

struct GraphView: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject var model: GraphModel
    
    enum DateIndicatorState {
        case yesterday
        case today
        case tomorrow
    }
    
    @State var topState: DateIndicatorState = .today
    @State var bottomState: DateIndicatorState = .today
    
    var body: some View {
        GeometryReader { outer in
            VStack(spacing: .zero) {
                DateIndicator(
                    dayHeight: outer.size.height * zero.zoomLevel - timeIndicatorHeightEstimate,
                    state: topState
                )
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        DayScroll(size: geo.size, top: geo.frame(in: .global).minY, bottom: geo.frame(in: .global).maxY)
                        GraphButtons()
                    }
                }
                /// allow graph to consume maximum height
                .layoutPriority(1)
                DateIndicator(
                    dayHeight: outer.size.height * zero.zoomLevel - timeIndicatorHeightEstimate,
                    state: bottomState
                )
            }
        }
    }
    
    func DayScroll(size: CGSize, top: CGFloat, bottom: CGFloat) -> some View {
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
                    GeometryReader { geo in
                        Run {
                            let castBackHeight = CGFloat(model.castBack / .day) * dayHeight
                            let topOffset = -geo.frame(in: .named(ScrollFrameName)).minY

                            let castFwrdHeight = CGFloat((model.castFwrd - .day) / .day) * dayHeight
                            let botOffset = geo.frame(in: .named(ScrollFrameName)).maxY - size.height

                            withAnimation {
                                topState = castBackHeight < topOffset
                                    ? .today
                                    : .yesterday
                                bottomState = castFwrdHeight < botOffset
                                    ? .today
                                    : .tomorrow
                            }
                        }
                    }
                    .frame(width: 0)
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
        .coordinateSpace(name: ScrollFrameName)
    }
}
