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
    /// number of days on screen
    static let dayCount = 31
    
    @State var dragBy = PositionTracker()
    @State var ticker = Ticker()
    
    let tf = DateFormatter()
    let haptic = UIImpactFeedbackGenerator(style: .light)
    init(){
        tf.timeStyle = .short
    }
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        VStack {
            Text("TESTING")
            GeometryReader { geo in
                ZStack {
                    Rectangle().foregroundColor(.clokBG) /// "invisible" background rectangle to make the whole area touch sensitive
                    ForEach(0..<LineGraph.dayCount, id: \.self) { days in
                        ForEach(data.entries.filter{withinDay(entry: $0, days: days)}, id: \.id) { entry in
                            LineBar(
                                entry: entry,
                                begin: zero.date + Double(days) * dayLength,
                                interval: zero.interval,
                                size: geo.size
                            )
                                .transition(.identity)
                                .offset(
                                    x: geo.size.width * CGFloat(days) / CGFloat(LineGraph.dayCount),
                                    y: .zero
                                )
                        }
                    }
                }
                .drawingGroup()
                .gesture(Drag(size: geo.size))
            }
            .border(Color.red)
        }
        .onAppear {
            /// update zero date to get app view to load data
            zero.date += TimeInterval.leastNonzeroMagnitude
        }
    }
    
    func withinDay(entry: TimeEntry, days: Int) -> Bool {
        let begin = zero.date + Double(days) * dayLength
        if entry.wrappedEnd < begin { return false }
        if entry.wrappedStart > begin + zero.interval { return false }
        return true
    }
    
    func Drag(size: CGSize) -> some Gesture {
        func useValue(value: DragGesture.Value, size: CGSize) -> Void {
            
            /// find cursor's offset (don't skip this, we want all movements tracked)
            dragBy.update(state: value, size: size)
        
            /// only run every so often
            guard ticker.tick() else { return }
            
            withAnimation {
                zero.date -= dragBy.harvestInterval() * zero.interval
            }
            
            let days = dragBy.harvestDays()
            if days != 0 {
                haptic.impactOccurred(intensity: 1)
                withAnimation {
                    zero.date -= Double(days) * dayLength
                }
                
            }
        }
        return DragGesture()
            .onChanged {
                useValue(value: $0, size: size)
            }
            .onEnded {
                /// update once more on end
                useValue(value: $0, size: size)
                dragBy.reset()
            }
    }
    
    struct Ticker {
        var counter = 0
        let limit = 2 /// only run every 1/limit times
        
        mutating func tick() -> Bool {
            counter = (counter + 1) % limit
            return counter == 0
        }
    }
}
