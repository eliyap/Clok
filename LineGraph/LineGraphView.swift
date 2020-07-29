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
                    ForEach(0..<LineGraph.dayCount, id: \.self) {
                        DayBar(dayOffset: $0, size: geo.size)
                    }
                }
                .drawingGroup()
                .gesture(Drag(size: geo.size))
            }
            .border(Color.red)
        }
    }
    
    func DayBar(dayOffset: Int, size: CGSize) -> some View {
        let zeroOffset = zero.date + Double(dayOffset) * dayLength
        let offset = size.width * CGFloat(dayOffset) / CGFloat(LineGraph.dayCount)
        return ForEach(data.entries.filter {$0.wrappedEnd > zeroOffset && $0.wrappedStart < zeroOffset + dayLength}, id: \.id) { entry in
            LineBar(entry: entry, begin: zeroOffset, interval: zero.interval, size: size)
                .transition(.opacity)
                .offset(x: offset, y: .zero)
        }
        .drawingGroup()
    }
    
    func Drag(size: CGSize) -> some Gesture {
        func useValue(value: DragGesture.Value, size: CGSize) -> Void {
            /// find cursor's offset
            dragBy.update(state: value, size: size)
        
            withAnimation {
                zero.date -= dragBy.intervalDiff * zero.interval
            }
            
            let days = dragBy.harvestDays()
            if days != 0 {
                haptic.impactOccurred(intensity: 1)
//                withAnimation {
                    zero.date -= Double(days) * dayLength
//                }
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
}
