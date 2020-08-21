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
    
    /// update this view every minute
    @State var date = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    let height: CGFloat
    let df = DateFormatter()
    let radius: CGFloat = 7
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .center, spacing: .zero) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: radius, height: radius)
                Rectangle()
                    .foregroundColor(.red)
                    .frame(height: 1)
            }
            Text(time)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.red)
                .padding(.trailing, radius)
        }
        /// allow the circle to bleed into the margin
        .padding(.leading, -radius / 2)
        .offset(y: offset)
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
