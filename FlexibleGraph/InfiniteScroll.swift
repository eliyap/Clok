//
//  InfiniteScroll.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    /** Enables user to scroll up (but not down) as far as they want.
     Important to my vision of allowing cross-day visualization.
     Built on a monstrous hack that exploits the behaviour of `LazyVStack`,
     wherein it doesn't scroll when views are added below (here rotated to be "above")
     */
    var InfiniteScroll: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: .zero) {
                        ForEach(RowList, id: \.self) { idx in
                            Page(idx: idx, size: geo.size)
                                /// flip view back over
                                .rotationEffect(.tau / 2)
                                /// if user hits the "last" (visually top) date, add another one "above" (by appending)
                                .onAppear {
                                    if idx == RowList.last {
                                        RowList.insert(RowList.last! - 1, at: RowList.count)
                                    }
                                }
                        }
                    }
                        /// go to center of range at startup
                        .onAppear { proxy.scrollTo(0) }
                }
            }
                /** Flipped over so user can infinitely scroll "up" (actually down) to previous days */
                .rotationEffect(.tau / 2)
        }
    }
}

// MARK:- Page
extension FlexibleGraph {
    /// Represents 1 Page in the InfiniteScroll column
    /// - Parameters:
    ///   - idx: the number of this page, determines which time period it renders
    ///   - size: the size of the page
    /// - Returns: `View`
    func Page(idx: Int, size: CGSize) -> some View {
        ZStack(alignment: .topLeading) {
            switch model.mode {
            case .dayMode:
                DayCalendar(size: size, idx: idx)
            case .weekMode:
                WeekCalendar(size: size, idx: idx)
            case .listMode:
                DayList(idx: idx)
            }
            StickyDateLabel(idx: idx)
        }
    }
}

// MARK:- Page Footer
extension FlexibleGraph {
    
    /// Renders a small date header
    /// - Parameters:
    ///   - idx: the number of this page, determines the date shown
    /// - Returns: `View`
    func StickyDateLabel(idx: Int) -> some View {
        /** Technical Note
         Spacer is the ideal solution for engineering a "Sticky" header
         - unlike `.offset`, it cannot push the view out of frame!
         - unlike `.offset`, it cannot go into negative height
         */
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: .zero) {
                Spacer()
                    .frame(maxHeight: bounds.insets.top - geo.frame(in: .global).minY)
                Color.red
                    .frame(height: 1)
                Text(Date()
                    .advanced(by: Double(idx) * .day)
                    .MMMdd
                )
                    .foregroundColor(.background)
                    .bold()
                    .padding([.leading, .trailing], 3)
                    .background(
                        MoldedRectangle(cornerRadius: 5)
                            .foregroundColor(.red)
                    )
            }
        }
    }
}
