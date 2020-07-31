//
//  DragHandler.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

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

