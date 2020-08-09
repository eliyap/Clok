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
            ForEach(
                Array(stride(
                    from: -model.castBack,
                    to: model.castFwrd,
                    by: dayLength / Double(divisions)
                )), id: \.self) {
                    TimeLabel(interval: $0)
                    Spacer()
            }
        }
    }
    
    /// format time according to user preference
    private func TimeLabel(interval: TimeInterval) -> some View {
        let midnight = Calendar.current.startOfDay(for: Date())
        /// show time according to 24 hour format
        if divisions > 24 { /// enable minute resolution
            tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH:mm" : "h:mm a")
        } else {
            tf.setLocalizedDateFormatFromTemplate(is24hour() ? "HH" : "h a")
        }
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
        let hours: String!
        switch divisions {
        case _ where divisions <= 24: /// integer division is safe
            hours = "\(idx * 24 / divisions)"
        case 24 * 2: /// half hours: 1 d.p.
            hours = String(format: "%.1f", Double(idx) * 24 / Double(divisions))
        case 24 * 4: /// quarter hours: 2 d.p.
            hours = String(format: "%.2f", Double(idx) * 24 / Double(divisions))
        default:
            hours = String(format: "%.2f", Double(idx) * 24 / Double(divisions))
        }
        return Text("\(hours) h")
            .padding([.leading, .trailing], labelPadding)
            .offset(y: -labelOffset)
    }
}
