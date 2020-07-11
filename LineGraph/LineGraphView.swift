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
    
    let tf = DateFormatter()
    init(){
        tf.timeStyle = .short
    }
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        HStack {
            
            GeometryReader { geo in
                ZStack {
                    Rectangle().foregroundColor(.clokBG)
                    VStack {
                        Text(tf.string(from: zero.date))
                        Spacer()
                        Text(zero.interval.toString())
                        Spacer()
                        Text(tf.string(from: zero.date + zero.interval))
                    }
                    .allowsHitTesting(false)
                    
                    ForEach(data.report.entries.filter {$0.end > zero.date && $0.start < zero.date + weekLength}, id: \.id) { entry in
                        LineBar(with: entry, geo: geo, bounds: GetBounds(zero: zero, entry: entry))
                            .transition(.identity)
                    }
                }
                .gesture(ExclusiveGesture(
                    Drag(geo: geo),
                    MagnificationGesture().updating($magnifyBy, body: magnifyHandler)
                ))
            }
            .border(Color.red)
        }
    }
    
    func timeOffset(for date: Date) -> String {
        (date - Calendar.current.startOfDay(for: zero.date))
            .truncatingRemainder(dividingBy: dayLength)
            .toString()
    }
    
    func Drag(geo: GeometryProxy) -> some Gesture {
        func useValue(value: DragGesture.Value, geo: GeometryProxy) -> Void {
            /// find cursor's
            dragBy.update(state: value, geo: geo)
            zero.date -= dragBy.intervalDiff * zero.interval
            let days = dragBy.harvestDays()
            if days != 0 {
                // HAPTIC FEEDBACK HERE
                zero.date -= Double(days) * dayLength
            }
        }
        return DragGesture()
            .onChanged {
                useValue(value: $0, geo: geo)
            }
            .onEnded {
                /// update once more on end
                useValue(value: $0, geo: geo)
                dragBy.reset()
            }
    }
}
