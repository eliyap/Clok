//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineGraph: View {
    
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var zero: ZeroDate
    /// for now, show 7 days
    static let dayCount = 7
    
    @GestureState var magnifyBy = CGFloat(1.0)

    /// slows down the magnifying effect by some constant
    private let kCoeff = 0.5
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
                /// get change in time
                let delta = Double(gestureState - magnifyBy) * dayLength * kCoeff
                
                /// adjust interval, but cap at reasonable quantity
                zero.interval -= delta
                zero.interval = max(zero.interval, 3600.0)
                zero.interval = min(zero.interval, dayLength)
                
                zero.date += delta / 2
            }
    }
    
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        GeometryReader { geo in
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
        }
        .gesture(magnification)
        .border(Color.red)
    }
    
    func timeOffset(for date: Date) -> String {
        (date - Calendar.current.startOfDay(for: zero.date))
            .truncatingRemainder(dividingBy: dayLength)
            .toString()
    }
}
