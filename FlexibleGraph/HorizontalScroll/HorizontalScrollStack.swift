//
//  HorizontalScrollStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    
    var HorizontalScrollStack: some View {
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
                            MonitoredStrip(
                                midnight: Date()
                                    .midnight
                                    .advanced(by: Double(idx) * .day + Double(rowPosition.position.y) * .day),
                                idx: idx,
                                trailing: geo.frame(in: .global).maxX,
                                proxy: proxy
                            )
                                .frame(width: geo.size.width / GraphConstants.dayCount)
                                .rotationEffect(.tau / 2)
                                /// if user hits the "last" (visually leftmost) date, add another one to the left (by appending)
                                .onAppear {
                                    if idx == RowList.last {
                                        RowList.insert(RowList.last! - 1, at: RowList.count)
                                    }
                                }
                        }
                    }
                        .onAppear {
                            print(rowPosition)
                            /// without the async, the `scrollTo` call is *extremely* inaccurate
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                proxy.scrollTo(
                                    rowPosition.row + 1,
                                    anchor: UnitPoint(
                                        x: GraphConstants.hProp * (1-rowPosition.position.x),
                                        y: 0
                                    )
                                )
                            }
                        }
                }
            }
                /** Flipped over so user can infinitely scroll "left" (actually right) to previous days */
                .rotationEffect(.tau / 2)
        }
    }
}
