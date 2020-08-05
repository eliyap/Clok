//
//  TimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// whitespace around time labels
fileprivate let labelPadding = CGFloat(3)

/// offset label upwards to rest on the line
fileprivate let labelOffset = CGFloat(-10)

struct TimeIndicator: View {
    let divisions: Int

    let tf = DateFormatter()
    
    init(divisions: Int) {
        self.divisions = divisions
        /// show hour in preferred way (no minutes or seconds)
        tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH" : "h a")
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            /// repeat for 3 days
            ForEach(0..<3, id: \.self) { _ in
                ForEach(0..<divisions, id: \.self) { idx in
                    Text("\(tf.string(from: Calendar.current.startOfDay(for: Date()) + Double(idx * 86400/divisions)))")
                        .font(.footnote)
                        .padding([.leading, .trailing], labelPadding)
                        .offset(y: labelOffset)
                    Spacer()
                }
            }
        }
    }
}
