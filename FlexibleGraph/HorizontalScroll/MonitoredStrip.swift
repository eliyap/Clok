//
//  MonitoredStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    func MonitoredStrip(midnight: Date, idx: Int) -> some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                Divider()
                    .onReceive(positionRequester) { _ in
                        let leadingOffset = bounds.insets.leading - geo.frame(in: .global).minX
                        if leadingOffset.isBetween(0, geo.size.width) {
                            rowPosition.row = idx
                            rowPosition.position.x = leadingOffset / geo.size.width
                        }
                    }
                DayStrip(midnight: midnight, idx: idx)
            }
                .frame(width: geo.size.width)
        }
    }
}
