//
//  PageAnchor.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// MARK:- Page Anchor
extension FlexibleGraph {
    
    /// An invisible anchor in the VerticalScroll for my `ScrollViewProxy` to latch onto
    /// - Parameter idx: the page number this is an anchor for
    func PageAnchor(for idx: Int, axis: Axis) -> some View {
        Color.clear
            /// NOTE: this view must be as small is possible without actually having 0 size
            .frame(
                width: axis == .horizontal ? 0.05 : .none,
                height: axis == .vertical ? 0.05 : .none
            )
            .id(Double(idx) + Self.idOffset)
    }
}
