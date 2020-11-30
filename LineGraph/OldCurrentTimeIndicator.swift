//
//  CurrentTimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 20/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/**
 Indicates and updates the current time
 */
struct CurrentTimeIndicator: View {
    
    @EnvironmentObject var model: GraphModel
    @EnvironmentObject var bounds: Bounds
    
    /// update this view every minute
    @State var date = Date()
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    let height: CGFloat
    let df = DateFormatter()
    let radius: CGFloat = 7
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: .zero) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: radius, height: radius)
                Rectangle()
                    .foregroundColor(.red)
                    .frame(height: 1)
            }
            Text(time)
                .font( bounds.device == .iPhone
                    ? Font.system(.caption2, design: .monospaced)
                    : Font.system(.caption, design: .monospaced)
                )
                .foregroundColor(.red)
        }
        /// allow the circle to bleed into the margin
        /// also nudge view upwards, ignoring the top half of the semi-circle
        .padding([.leading, .top], -radius / 2)
        .offset(y: offset)
        .onReceive(timer) { date in
            self.date = date
        }
        .transition(.opacity)
    }
    
    private var offset: CGFloat {
        let seconds = TimeInterval(date.hour * 3600 + date.minute * 60) + model.castBack
        let proportion = seconds / (model.days * .day)
        return height * CGFloat(proportion)
    }
    
    private var time: String {
        df.timeStyle = .short
        return df.string(from: date)
    }
}
