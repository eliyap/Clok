//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineGraph: View {
    
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var data: TimeData

    let offset: Int
    let tf = DateFormatter()
    let haptic = UIImpactFeedbackGenerator(style: .light)
    let size: CGSize
    
    init(offset: Int, size: CGSize){
        tf.timeStyle = .short
        self.offset = offset
        self.size = size
    }
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
    
    func enumDays() -> [(Int, Date)] {
        stride(from: 0, to: zero.dayCount, by: 1).map{
            ($0, Calendar.current.startOfDay(for: zero.date) + Double($0 + offset) * dayLength)
        }
    }
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        ZStack {
            /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
            ForEach(
                enumDays(),
                id: \.1.timeIntervalSince1970
            ) { idx, date in
                DayStrip(
                    entries: data.entries.filter{$0.end > date && $0.start < date + dayLength},
                    begin: date,
                    size: size,
                    terms: data.terms,
                    dayCount: zero.dayCount
                )
                .transition(slideOver())
                .offset(x: size.width * CGFloat(idx) / CGFloat(zero.dayCount))
            }
        }
    }
    
    func slideOver() -> AnyTransition {
        switch zero.dateChange {
        case .fwrd:
            return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        case .back:
            return .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        case .none:
            return .opacity
        }
    }
}


/// One vertical strip of bars representing 1 day in the larger graph
struct DayStrip: View {
    
    let entries: [TimeEntry]
    let begin: Date
    let size: CGSize
    let terms: SearchTerm
    let dayCount: Int
    
    var body: some View {
        ForEach(entries, id: \.id) { entry in
            LineBar(
                entry: entry,
                begin: begin,
                size: CGSize(
                    /// reflect the smaller width
                    width: size.width / CGFloat(dayCount),
                    height: size.height
                )
            )
                .opacity(entry.matches(terms) ? 1 : 0.5)
        }
    }
}
