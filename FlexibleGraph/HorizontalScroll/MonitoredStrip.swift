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
            ZStack {
                HStack(spacing: .zero) {
                    Divider()
                    DayStrip(midnight: midnight, idx: idx)
                }
                    .frame(width: geo.size.width)
                    .onReceive(positionRequester) { adjustRow(trailing: trailing, geo: geo, proxy: proxy, idx: idx, rowAdjustment: $0) }
                VStack {
                    VStack(spacing: .zero) {
                        Text(midnight.shortWeekday)
                            .font(Font.footnote.boldIfToday(date: midnight))
                            .lineLimit(1)
                            .foregroundColor(color(for: midnight))
                        DateLabel(for: midnight)
                            .font(Font.caption.boldIfToday(date: midnight))
                            .lineLimit(1)
                            .foregroundColor(color(for: midnight))
                    }
                    Spacer()
                        .frame(maxHeight: .infinity)
                    Text("bot")
                }
            }
        }
    }
    
    func DateLabel(for date: Date) -> Text {
        let df = DateFormatter()
        if Calendar.current.component(.day, from: date) == 1 {
            df.setLocalizedDateFormatFromTemplate("MMM")
            return Text(df.string(from: date)).bold()
        } else {
            df.setLocalizedDateFormatFromTemplate("dd")
            return Text(df.string(from: date))
        }
    }
    
    
    /**
     determine the correct color to use for this date
     */
    private func color(for date: Date) -> Color {
        switch Date() - date {
        case let diff where diff < 0: /// date is in the future
            return .secondary
        case let diff where diff < .day: /// date is today
            return .red
        default: /// date is in the past
            return .primary
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

/**
 bold the font if the provided date is today
 */
fileprivate extension Font {
    func boldIfToday(date: Date) -> Font {
        let diff = Date() - date
        guard diff > 0 else { return self }
        guard diff < .day else { return self }
        return self.bold()
    }
}
