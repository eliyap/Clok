//
//  EntryRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// determines what proportion of available horizontal space to consume
fileprivate let thicc = CGFloat(0.8)

/// adapt scale to taste
fileprivate let cornerScale = CGFloat(1.0/18.0)

struct EntryRect: View {
    
    @EnvironmentObject var model: GraphModel
    
    let range: DateRange
    let size: CGSize
    let midnight: Date
    
    /// toggles solid fill or animated border
    var border: Bool = false
    
    /// credit: https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-marching-ants-border-effect
    @State private var opacity = 0.25
    
    var body: some View {
        if border {
            /// animated border outline version
            RoundedRectangle(cornerRadius: size.width * cornerScale)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .opacity(opacity)
                .onAppear { opacity = 1.0 }
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true))
                .frame(
                    width: size.width * thicc,
                    height: height
                )
        }
        /// avoid an invalid size warning
        else if height > 0 {
            RoundedRectangle(cornerRadius: size.width * cornerScale)
                .frame(
                    width: size.width * thicc,
                    height: height
                )
        }
    }
    
    /**
     Calculate the appropriate height for a time entry.
     */
    var height: CGFloat {
        let start = max(range.start, midnight - model.castBack)
        let end = min(range.end, midnight + model.castFwrd)
        return size.height * CGFloat((end - start) / (.day * model.days))
    }
}
