//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let itemCount = 4

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    
    
    @State var items: [UUID] = stride(from: 0, to: itemCount, by: 1).map{_ in UUID()}
    
    @State var offset = CGFloat.zero
    @State var handler = DragHandler()
    
    func enumDays() -> [(Int, Date)] {
        stride(from: 0, to: 5, by: 1).map{
            ($0, Calendar.current.startOfDay(for: zero.date) + Double($0) * dayLength)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    InfiniteScroll(geo: geo)
                }
                FilterStack()
                    .padding(buttonPadding)
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
    }
    
    func InfiniteScroll(geo: GeometryProxy) -> some View {
        VStack {
            ForEach(Array(zip(items.indices, items)), id: \.1) { idx, item in
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .border(Color.red)
                    .opacity((idx == 0 || idx == 3) ? 0.5 : 1)
            }
        }
        .padding([.top, .bottom], -geo.size.height)
        .offset(y: offset)
        .gesture(DragGesture()
            .onChanged {value in
                withAnimation {
                    handler.update(value: value, height: geo.size.height, offset: $offset, popUp: popUp, popDown: popDown)
                }
            }
            .onEnded { value in
                
                handler.lastUpdate(value: value, height: geo.size.height, offset: $offset)
            }
                 
        )
    }
    
    func popUp() -> Void {
        withAnimation {
            items.insert(UUID(), at: 0)
            items.removeLast()
        }
    }
    
    func popDown() -> Void {
        withAnimation {
            items.append(UUID())
            items.removeFirst()
        }
    }
}


struct DragHandler {
    var translation: CGPoint = .zero
    var topGap: CGFloat = .zero
    var botGap: CGFloat = .zero
    let frustration = CGFloat(0.2)
    let threshold = CGFloat(0.4)
    
    let haptic = UINotificationFeedbackGenerator()
    
    mutating func update(
        value: DragGesture.Value,
        height: CGFloat,
        offset: Binding<CGFloat>,
        popUp: () -> (),
        popDown: () -> ()
    ) -> Void {
        let movement = (value.location - value.startLocation - translation).y
        let newOffset = offset.wrappedValue + movement
        
        if topGap > threshold * height {
            popUp()
            offset.wrappedValue = newOffset + topGap - height
            topGap = -.infinity /// prevent it ever being popped again
            haptic.notificationOccurred(.success)
            return
        }
        if botGap < threshold * -height {
            popDown()
            offset.wrappedValue = newOffset + height + botGap
            botGap = +.infinity /// prevent it ever being popped again
            haptic.notificationOccurred(.success)
            return
        }
        
        if newOffset > 0 {
            offset.wrappedValue += movement * frustration
            topGap += movement * (1 - frustration)
            haptic.prepare()
        } else if newOffset < -height {
            offset.wrappedValue += movement * frustration
            botGap += movement * (1 - frustration)
            haptic.prepare()
        }
        else {
            offset.wrappedValue = newOffset
        }
        
        translation = value.location - value.startLocation
    }
    
    mutating func lastUpdate(value: DragGesture.Value, height: CGFloat, offset: Binding<CGFloat>) -> Void {
        let predictedOffset = offset.wrappedValue + (value.predictedEndLocation - value.startLocation - translation).y
        if predictedOffset > 0 {
            withAnimation(.spring()) {
                offset.wrappedValue = 0
            }
        } else if predictedOffset < -height {
            withAnimation(.spring()) {
                offset.wrappedValue = -height
            }
        } else {
            withAnimation(.easeOut(duration: 0.4)) {
                offset.wrappedValue = predictedOffset
            }
        }
        topGap = .zero
        botGap = .zero
        translation = .zero
    }
}
