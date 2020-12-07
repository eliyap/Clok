//
//  StickyDateLabel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// MARK:- Page Footer
extension FlexibleGraph {
    
    /// Renders a small date header
    /// - Parameters:
    ///   - idx: the number of this page, determines the date shown
    /// - Returns: `View`
    func StickyDateLabel(idx: Int) -> some View {
        /** Technical Note
         Spacer is the ideal solution for engineering a "Sticky" header
         - unlike `.offset`, it cannot push the view out of frame!
         - unlike `.offset`, it cannot go into negative height
         */
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: .zero) {
                Spacer()
                    .frame(maxHeight: bounds.insets.top - geo.frame(in: .global).minY)
                Color.red
                    .frame(height: 1)
                Text(Date()
                    .advanced(by: Double(idx) * .day)
                    .MMMdd
                )
                    .foregroundColor(.background)
                    .bold()
                    .padding([.leading, .trailing], 3)
                    .background(
                        MoldedRectangle(cornerRadius: 5)
                            .foregroundColor(.red)
                    )
            }
            .onReceive(positionRequester) { _ in
                getPosition(geo: geo, idx: idx)
            }
        }
    }
    
    
    /// Gets a normalized position within the `GeometryReader` of the current page
    /// - Parameters:
    ///   - geo: GeometryProxy of the page
    ///   - idx: page number
    /// relies on `geo` being somewhere in a `ZStack` with unconstrained `frame`
    func getPosition(geo: GeometryProxy, idx: Int) -> Void {
        let topOffset = bounds.insets.top - geo.frame(in: .global).minY
        if topOffset.isBetween(0, geo.size.height) {
            rowPosition = RowPositionModel(
                row: idx,
                position: UnitPoint(x: .zero, y: topOffset/geo.size.height)
            )
        }
    }
}
