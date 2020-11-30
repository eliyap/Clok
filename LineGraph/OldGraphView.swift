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
    
    enum DateIndicatorState: Int {
        case yesterday = 0
        case today = 1
        case tomorrow = 2
    }
    
    @State var topState: (DateIndicatorState, AnyTransition?) = (.today, .none)
    @State var bottomState: (DateIndicatorState, AnyTransition?) = (.today, .none)
    
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
                if model.mode == .calendar {
                    DateIndicator(
                        dayHeight: outer.size.height * zero.zoomLevel - timeIndicatorHeightEstimate,
                        state: bottomState
                    )
                }
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
                    DayReader(dayHeight: dayHeight, size: size)
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
    
    /**
     invisible view that harvests information about the scroll position of the graph
     and tells the `DateIndicator`s whether to display yesterday, today, or tomorrow
     */
    func DayReader(dayHeight: CGFloat, size: CGSize) -> some View {
        GeometryReader { geo in
            Run {
                /// no need for this if we are in graph mode
                guard model.mode != .graph else { return }
                
                let nBack = CGFloat(model.castBack / .day)
                let topOffset = -geo.frame(in: .named(ScrollFrameName)).minY

                let nFwrd = CGFloat(model.castFwrd / .day)
                let botOffset = geo.frame(in: .named(ScrollFrameName)).maxY - size.height

                /// update state and figure out animation
                let newTopState: DateIndicatorState = {
                    switch topOffset / dayHeight {
                    case let x where x < nBack:
                        return .yesterday
                    case let x where nBack <= x && x <= nBack + 1:
                        return .today
                    default:
                        return .tomorrow
                    }
                }()
                topState.1 = {
                    switch (newTopState.rawValue, topState.0.rawValue) {
                    case let (x, y) where x < y:
                        return .slideRight
                    case let (x, y) where x > y:
                        return .slideLeft
                    default:
                        return .none
                    }
                }()
                
                let newBottomState: DateIndicatorState = {
                    switch botOffset / dayHeight {
                    case let x where x > nFwrd:
                        return .yesterday
                    case let x where nFwrd >= x && x >= nFwrd - 1:
                        return .today
                    default:
                        return .tomorrow
                    }
                }()
                bottomState.1 = {
                    switch (newBottomState.rawValue, bottomState.0.rawValue) {
                    case let (x, y) where x < y:
                        return .slideRight
                    case let (x, y) where x > y:
                        return .slideLeft
                    default:
                        return .none
                    }
                }()
                
                /// now that animation is set, communicate state
                withAnimation {
                    topState.0 = newTopState
                    bottomState.0 = newBottomState
                }
            }
        }
        .frame(width: 0)
    }
}
