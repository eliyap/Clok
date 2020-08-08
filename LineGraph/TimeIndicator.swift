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
    
    @EnvironmentObject var model: GraphModel
    
    let divisions: Int
    let tf = DateFormatter()
    
    init(divisions: Int) {
        self.divisions = divisions
        /// show hour in preferred way
        if divisions > 24 { /// minute resolution
            tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH:mm" : "h:mm a")
        } else {
            tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH" : "h a")
        }
        
    }
    
    var body: some View {
        CalendarTime
    }
    
    var CalendarTime: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .trailing) {
                ForEach(0..<Int(model.days)) { _ in
                    /// midnight is specially bolded
                    Text("\(tf.string(from: Calendar.current.startOfDay(for: Date())))")
                        .bold()
                        .font(.footnote)
                        .padding([.leading, .trailing], labelPadding)
                        .offset(y: labelOffset)
                    Spacer()
                    ForEach(1..<divisions, id: \.self) { idx in
                        /// format the hour according to user preference
                        Text("\(tf.string(from: Calendar.current.startOfDay(for: Date()) + Double(idx * 86400/divisions)))")
                            .font(.footnote)
                            .padding([.leading, .trailing], labelPadding)
                            .offset(y: labelOffset)
                        Spacer()
                    }
                }
            }
            Divider()
        }
    }
}
