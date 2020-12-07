//
//  HorizontalScroll.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    
    var HorizontalScroll: some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                NewTimeIndicator(divisions: evenDivisions(for: geo.size.height))
                    .gesture(DragGesture()
                        .onChanged { state in
                            rowPosition.position.y += state.translation.height / geo.size.height
                        }
                    )
                HorizontalScrollView
            }
        }
    }
    
    var HorizontalScrollView: some View {
        /** Enables user to scroll left (but not right) as far as they want.
         Important to my vision of allowing cross-day visualization.
         Built on a monstrous hack that exploits the behaviour of `LazyHStack`,
         wherein it doesn't scroll when views are added to the front
         */
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyHStack(spacing: .zero) {
                        ForEach(RowList, id: \.self) { idx in
                            
                            WeekStrip(
                                midnight: Date()
                                    .midnight
                                    /// NOTE: -1 is a magic number to correct for offset
                                    .advanced(by: Double(idx) * .day + Double(rowPosition.position.y) * .day),
                                row: idx,
                                /// NOTE: col is somewhat meaningless and does NOT match midnight
                                col: Date().midnight.advanced(by: Double(idx) * .day).timeIntervalSince1970
                            )
                                .frame(
                                    width: geo.size.width / 7,
                                    height: geo.size.height
                                )
                                .rotationEffect(.tau / 2)
                                /// if user hits the "last" (visually leftmost) date, add another one to the left (by appending)
                        }
                    }
                    .onChange(of: requestedPosition) { req in
                        print(requestedPosition)
                        proxy.scrollTo(Double(req.row + 1) + 0.5, anchor: req.position)
                    }
                }
            }
                /** Flipped over so user can infinitely scroll "left" (actually right) to previous days */
                .rotationEffect(.tau / 2)
        }
    }
}
