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

struct NewTimeIndicator: View {
    
    let divisions: Int
    let tf = DateFormatter()
    
    var body: some View {
        HStack(spacing: .zero) {
            CalendarTime
            Divider()
        }
    }
    
    /// time indicators shown in `.calendar` mode
    /// closely mimics Google Calendar or other generic calendar app
    var CalendarTime: some View {
        VStack(alignment: .trailing) {
            ForEach(
                Array(stride(
                    from: 0,
                    to: .day,
                    by: .day / Double(divisions)
                )), id: \.self) {
                    TimeLabel(interval: $0)
                        .foregroundColor(.gray)
                    Spacer()
            }
        }
    }
    
    /// format time according to user preference
    private func TimeLabel(interval: TimeInterval) -> some View {
        /// show time according to 24 hour format
        if divisions > 24 { /// enable minute resolution
            tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH:mm" : "h:mm a")
        } else {
            tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH" : "h a")
        }
        var text = Text("\(tf.string(from: Date().midnight + interval))")
            .font(.footnote)
        /// midnight is specially bolded
        if interval.remainder(dividingBy: .day) == 0 {
            text = text.bold()
        }
        return text
            .padding([.leading, .trailing], labelPadding)
    }
}
