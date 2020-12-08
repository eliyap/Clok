//
//  MonitoredStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    func MonitoredStrip(
        midnight: Date,
        idx: Int,
        trailing: CGFloat,
        proxy: ScrollViewProxy
    ) -> some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                Divider()
                DayStrip(midnight: midnight, idx: idx)
            }
                .frame(width: geo.size.width)
                .onReceive(positionRequester) { adjustRow(trailing: trailing, geo: geo, proxy: proxy, idx: idx, rowAdjustment: $0) }
        }
    }
    
    
    /// Responsds to a request to get and potentially set the `ScrollView`'s position
    /// - Parameters:
    ///   - trailing: distace to the trailing edge of the parent `ScrollView` in `.global` coordinates
    ///   - geo: `GeometryProxy` of this column
    ///   - proxy: `ScrollViewProxy` of the parent `ScrollView`, allowing us to set a new position
    ///   - idx: index of this column
    ///   - rowAdjustment: requested change to the scroll position
    func adjustRow(
        trailing: CGFloat,
        geo: GeometryProxy,
        proxy: ScrollViewProxy,
        idx: Int,
        rowAdjustment: Int?
    ) -> Void {
        let trailingOffset = trailing - geo.frame(in: .global).maxX

        /// conditional ensures that only the strip actually intersecting the trailing edge of the screen will report its position
        if trailingOffset.isBetween(0, geo.size.width) {
            rowPosition.row = idx
            rowPosition.position.x = trailingOffset / geo.size.width
        }
        
        /// adjust row, if requested
        guard let rowAdjustment = rowAdjustment else {
            return
        }
        
        proxy.scrollTo(
            rowPosition.row + 1 + rowAdjustment,
            anchor: UnitPoint(
                x: GraphConstants.hProp * (1-rowPosition.position.x),
                y: 0
            )
        )
    }
}
