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
    
    var body: some View {
        GeometryReader { geo in
            Rectangle().foregroundColor(.red) /// "invisible" background rectangle to make the whole area touch sensitive
                .gesture(Drag(size: geo.size))
        }
    }
    
    func Drag(size: CGSize) -> some Gesture {
        func useValue(value: DragGesture.Value, size: CGSize) -> Void {
            /// find cursor's offset (don't skip this, we want all movements tracked)
            dragBy.update(state: value, size: size)
                        
            let days = dragBy.harvestDays()
            if days != 0 {
                withAnimation {
                    zero.date -= Double(days) * dayLength
                }
                
            }
        }
        return DragGesture()
            .onChanged {
                dragBy.update(state: $0, size: size)
            }
            .onEnded {
                /// update once more on end
                useValue(value: $0, size: size)
                dragBy.reset()
            }
    }
}


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
        stride(from: 0, to: LineGraph.dayCount, by: 1).map{
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
                ForEach(
                    data.entries
                        .filter{$0.end > date && $0.start < date + dayLength}
                    , id: \.id
                ) { entry in
                    LineBar(
                        entry: entry,
                        begin: date,
                        size: size
                    )
                        .opacity(entry.matches(data.terms) ? 1 : 0.5)
                }
                .transition(.opacity)
                .offset(
                    x: size.width * CGFloat(idx) / CGFloat(LineGraph.dayCount)
                )
            }
        }
    }
}
