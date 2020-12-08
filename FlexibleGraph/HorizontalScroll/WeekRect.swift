//
//  WeekRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    //MARK:- WeekRect
    func WeekRect(
        entry: TimeEntry,
        size: CGSize,
        midnight: Date,
        idx: Int
    ) -> some View {
        let height = size.height * CGFloat((entry.end - entry.start) / .day)
        return entry.color(in: colorScheme)
            /// note: 1/18 is an arbitrary ratio, adjust to taste
            .cornerRadius(min(size.width / 18.0, height / 2))
            .matchedGeometryEffect(
                id: NamespaceModel(entryID: entry.id, dayIndex: idx),
                in: graphNamespace,
                isSource: model.selected == .none
            )
            .matchedGeometryEffect(
                id: NamespaceModel(entryID: entry.id, dayIndex: idx).mirror,
                in: graphNamespace,
                isSource: model.selected == .none
            )
            /// note: 0.8 is an arbitrary ratio, adjust to taste
            .frame(width: size.width * 0.8, height: height)
    }
}
