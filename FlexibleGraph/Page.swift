//
//  Page.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// MARK:- Page
extension FlexibleGraph {
    /// Represents 1 Page in the InfiniteScroll column
    /// - Parameters:
    ///   - idx: the number of this page, determines which time period it renders
    ///   - size: the size of the page
    /// - Returns: `View`
    func Page(idx: Int, size: CGSize) -> some View {
        ZStack(alignment: .topLeading) {
            switch model.mode {
            case .dayMode:
                DayCalendar(size: size, idx: idx)
            case .listMode:
                DayList(idx: idx)
            }
            StickyDateLabel(idx: idx)
        }
    }
}

