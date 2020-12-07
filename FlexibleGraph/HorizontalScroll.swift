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
                                .rotationEffect(.tau / 2)
                                /// if user hits the "last" (visually leftmost) date, add another one to the left (by appending)
                            DayStack(size: geo.size, idx: idx)
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
