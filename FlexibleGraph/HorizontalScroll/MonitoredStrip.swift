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
                .onReceive(positionRequester) { rowAdjustment in
                    let trailingOffset = trailing - geo.frame(in: .global).maxX
                    print(trailingOffset)
                    /// conditional ensures that only the strip actually intersecting the trailing edge of the screen will report its position
                    if trailingOffset.isBetween(0, geo.size.width) {
                        rowPosition.row = idx
                        rowPosition.position.x = trailingOffset / geo.size.width
                        #warning("DEBUG")
                        print(rowPosition)
                    }
                    
                    /// adjust row, if requested
                    guard let rowAdjustment = rowAdjustment else {
                        return
                    }
                    
                    proxy.scrollTo(rowPosition.row + rowAdjustment, anchor: rowPosition.position)
                }
        }
    }
}
