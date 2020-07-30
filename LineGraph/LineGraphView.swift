//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct Controller: View {
    @EnvironmentObject var zero: ZeroDate
    
    @State var dragBy = PositionTracker()
    @State var ticker = Ticker()
    
    var body: some View {
        GeometryReader { geo in
            Rectangle().foregroundColor(.clokBG) /// "invisible" background rectangle to make the whole area touch sensitive
                .gesture(Drag(size: geo.size))
        }
        
    }
    
    func Drag(size: CGSize) -> some Gesture {
        func useValue(value: DragGesture.Value, size: CGSize) -> Void {
            
            /// find cursor's offset (don't skip this, we want all movements tracked)
            dragBy.update(state: value, size: size)
        
            /// only run every so often
            guard ticker.tick() else { return }
                        
            let days = dragBy.harvestDays()
            if days != 0 {
//                haptic.impactOccurred(intensity: 1)
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


struct LineGraph: View {
    
    @EnvironmentObject var data: TimeData
    /// number of days on screen
    static let dayCount = 31
    
    let date: Date
    let tf = DateFormatter()
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    init(date: Date){
        tf.timeStyle = .short
        self.date = date
    }
    
    /// slows down the magnifying effect by some constant
    let kCoeff = 0.5
    
    func enumDays() -> [(Int, Date)] {
        stride(from: 0, to: LineGraph.dayCount, by: 1).map{
            ($0, date + Double($0) * dayLength)
        }
    }
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        GeometryReader { geo in
            ZStack {
                /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
                ForEach(
                    enumDays(),
                    id: \.1.timeIntervalSince1970
                ) { idx, date in
                    ForEach(data.entries.filter{withinDay(entry: $0, begin: date)}, id: \.id) { entry in
                        LineBar(
                            entry: entry,
                            begin: date,
                            size: geo.size
                        )
                            .transition(.identity)
                            .opacity(entry.matches(data.terms) ? 1 : 0.5)
                            .offset(
                                x: geo.size.width * CGFloat(idx) / CGFloat(LineGraph.dayCount),
                                y: .zero
                            )
                    }
                }
            }
        }
    }
    
    func withinDay(entry: TimeEntry, begin: Date) -> Bool {
        if entry.wrappedEnd < begin { return false }
        if entry.wrappedStart > begin + dayLength { return false }
        return true
    }
}
