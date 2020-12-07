//
//  VerticalScroll.swift
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
    var VerticalScroll: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: .zero) {
                        ForEach(RowList, id: \.self) { idx in
                            /// invisible anchor shape for `scrollTo` to latch onto
                            PageAnchor(for: idx, axis: .vertical)
                            /// for a variety of uninteresting reasons, this frame cannot be used by `scrollTo`
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
                    .onAppear {
                        /// without the async, the `scrollTo` call is *extremely* inaccurate
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            proxy.scrollTo(Double(rowPosition.row) + Self.idOffset, anchor: rowPosition.position)
                        }
                    }
                    .onChange(of: requestedPosition) { req in
                        print(requestedPosition)
                        proxy.scrollTo(Double(req.row) + Self.idOffset, anchor: req.position)
                    }
                }
            }
                /** Flipped over so user can infinitely scroll "up" (actually down) to previous days */
                .rotationEffect(.tau / 2)
        }
    }
}
