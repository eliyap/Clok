//
//  DayStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let labelOffset = CGFloat(-10)
fileprivate let labelPadding = CGFloat(3)

/// One vertical strip of bars representing 1 day in the larger graph
struct DayStrip: View {
    @EnvironmentObject var bounds: Bounds
    let entries: [TimeEntry]
    let begin: Date
    let terms: SearchTerm
    let dayCount: Int
    let dfDay = DateFormatter()
    let dfMonth = DateFormatter()
    
    init(
        entries: [TimeEntry],
        begin: Date,
        terms: SearchTerm,
        dayCount: Int
    ){
        self.entries = entries
        self.begin = begin
        self.terms = terms
        self.dayCount = dayCount
        dfDay.setLocalizedDateFormatFromTemplate("dd")
        dfMonth.setLocalizedDateFormatFromTemplate("MMM")
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ForEach(entries, id: \.id) { entry in
                    LineBar(
                        entry: entry,
                        begin: begin,
                        size: geo.size
                    )
                        .opacity(entry.matches(terms) ? 1 : 0.5)
                }
//                StickyHeader(geo: geo)
            }
            .frame(width: geo.size.width)
        }
    }
    
    /// sticks to the top of the screen after scrolling at least `threshhold` down
    func StickyHeader(geo: GeometryProxy) -> some View {
        let rect = RoundedRectangle(cornerRadius: 7)
        let background = rect
            .foregroundColor(Color(UIColor.systemBackground))
            .overlay(rect.stroke(Color(UIColor.secondaryLabel)))
        
        /// how far down we've scrolled
        let topOffset = bounds.insets.top - geo.frame(in: .global).minY  - labelOffset
        
        /// limit to stick to the top
        let stickLimit = geo.size.height / 3 + labelOffset
        
        /// limit to switch to a different date
        let transformLimit = 2 * geo.size.height / 3  + labelOffset
        
        var label: String!
        var offset: CGFloat!
        
        switch topOffset {
        case _ where topOffset <= stickLimit:
            label = Label(for: begin)
            offset = stickLimit
        case _ where stickLimit < topOffset && topOffset < transformLimit :
            label = Label(for: begin)
            offset = topOffset
        case _ where transformLimit <= topOffset:
            label = Label(for: begin + dayLength)
            offset = topOffset
        default:
            label = "unexpected case!"
            offset = topOffset
        }
        return Text(label)
            .lineLimit(1)
            .frame(width: geo.size.width)
            .padding([.top, .bottom], labelPadding / 2)
            .background(background)
            .offset(y: offset)
            .minimumScaleFactor(0.01)
    }
    
    func Label(for date: Date) -> String {
        /// add 1 day to compensate for the day strip covering 3 days
        let date = date + dayLength
        if Calendar.current.component(.day, from: date) == 1 {
            return dfMonth.string(from: date)
        } else {
            return dfDay.string(from: date)
        }
    }
}
