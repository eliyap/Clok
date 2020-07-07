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
    @State private var length: TimeInterval = dayLength
    /// for now, show 7 days
    static let dayCount = 7
    
    @GestureState var magnifyBy = CGFloat(1.0)

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
                let delta = Double(gestureState - magnifyBy) * dayLength
                length += delta
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
                    Text(length.toString())
                    Spacer()
                    Text(timeOffset(for: zero.date + length))
                }.allowsHitTesting(false)
                
                ForEach(data.report.entries.filter {$0.end > zero.date && $0.start < zero.date + weekLength}, id: \.id) { entry in
                    LineBar(with: entry, interval: length, geo: geo)
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
