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
        HStack(spacing: .zero) {
            switch model.mode {
            case .calendar:
                CalendarTime
            default:
                GraphTime
            }
            Divider()
        }
    }
    
    /// time indicators shown in `.calendar` mode
    /// closely mimics Google Calendar or other generic calendar app
    var CalendarTime: some View {
        VStack(alignment: .trailing) {
            ForEach(0..<Int(model.days)) { _ in
                ForEach(0..<divisions, id: \.self) {
                    TimeLabel(idx: $0)
                    Spacer()
                }
            }
        }
    }
    
    /// format time according to user preference
    private func TimeLabel(idx: Int) -> some View {
        let interval = TimeInterval(idx * 86400/divisions)
        let midnight = Calendar.current.startOfDay(for: Date())
        var text = Text("\(tf.string(from: midnight + interval))")
            .font(.footnote)
        /// midnight is specially bolded
        if interval.remainder(dividingBy: dayLength) == 0 {
            text = text.bold()
        }
        return text
            .padding([.leading, .trailing], labelPadding)
            .offset(y: labelOffset)
    }
    
    /// time indicators shown in `.graph` mode
    var GraphTime: some View {
        VStack(alignment: .trailing) {
            ForEach((0..<divisions).reversed(), id: \.self) {
                Spacer()
                GraphLabel(idx: $0)
            }
        }
    }
    
    private func GraphLabel(idx: Int) -> some View {
        Text("\(idx)")
            .offset(y: -labelOffset)
    }
}
