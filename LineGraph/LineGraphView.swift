//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineGraph: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    /// for now, show 7 days
    static let dayCount = 7
    
    @GestureState var magnifyBy = CGFloat(1.0)
    @State var dragBy = PositionTracker()
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        return GeometryReader { geo in
            ZStack {
                Rectangle().foregroundColor(.green)
                VStack {
                    Text(timeOffset(for: zero.date))
                    Spacer()
                    Text(zero.interval.toString())
                    Spacer()
                    Text(timeOffset(for: zero.date + zero.interval))
                }.allowsHitTesting(false)
                
                ForEach(data.report.entries.filter {$0.end > zero.date && $0.start < zero.date + weekLength}, id: \.id) { entry in
                    LineBar(with: entry, geo: geo)
                }
            }
            .gesture(ExclusiveGesture(
                DragGesture()
                    .onChanged { value in
                        /// find cursor's
                        dragBy.update(state: value, geo: geo)
                        zero.date -= dragBy.dayDiff
                    }
                    .onEnded { value in
                        /// update once more on end
                        dragBy.update(state: value, geo: geo)
                        zero.date -= dragBy.dayDiff
                        dragBy.reset()
                    },
                MagnificationGesture().updating($magnifyBy, body: magnifyHandler)
            ))
        }
        .border(Color.red)
    }
    
    func timeOffset(for date: Date) -> String {
        (date - Calendar.current.startOfDay(for: zero.date))
            .truncatingRemainder(dividingBy: dayLength)
            .toString()
    }
}
