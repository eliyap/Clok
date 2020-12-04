//
//  WeekRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    //MARK:- WeekRect
    func WeekRect(
        entry: TimeEntry,
        size: CGSize,
        midnight: Date,
        animationInfo: (row: Int, col: Double)
    ) -> some View {
        let height = size.height * CGFloat((entry.end - entry.start) / .day)
        return entry.color(in: mode)
            /// note: 1/18 is an arbitrary ratio, adjust to taste
            .cornerRadius(min(size.width / 18.0, height / 2))
            /// note: 0.8 is an arbitrary ratio, adjust to taste
            .matchedGeometryEffect(
                id: NamespaceModel(
                    entry: entry,
                    row: animationInfo.row,
                    col: animationInfo.col
                ),
                in: namespace,
                isSource: !showEntry
            )
            .frame(width: size.width * 0.8, height: height)
    }
}
