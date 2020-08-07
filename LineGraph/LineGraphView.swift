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
    @EnvironmentObject var model: GraphModel

    
    /// visual height for 1 day
    let dayHeight: CGFloat
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
//    let mode: BarStack.Mode
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        HStack(spacing: .zero) {
            /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
            ForEach(
                Array(stride(from: zero.start, to: zero.end, by: dayLength)),
                id: \.timeIntervalSince1970
            ) { midnight in
                Divider()
                DayStrip(
                    entries: entries(midnight: midnight),
                    begin: midnight - model.castBack,
                    terms: data.terms,
                    dayHeight: dayHeight
                )
                .transition(slideOver())
                .frame(height: dayHeight * CGFloat(model.days))
            }
            /// vary background based on daycount
            .background(LinedBackground(height: dayHeight, days: Int(model.days)))
        }
        .drawingGroup()
    }
    
    func entries(midnight: Date) -> [TimeEntry] {
        switch model.mode {
        case .calendar: return data.entries
            .filter{$0.end > midnight - model.castBack}
            .filter{$0.start < midnight + model.castFwrd}
            .sorted{$0.start < $1.start}
        case .graph: return data.entries
            .filter{$0.end > midnight - model.castBack}
            .filter{$0.start < midnight + model.castFwrd}
            .sorted{$0.wrappedProject.wrappedName < $1.wrappedProject.wrappedName}
        }
    }
    
    /**
     determine what kind of apperance / disappearance animation to use
     based on whether the anchor date was just moved forwards for backwards
     */
    func slideOver() -> AnyTransition {
        switch zero.dateChange {
        case .fwrd:
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .back:
            return .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            )
        default: // fallback option, fade in and out
            return .opacity
        }
    }
}
