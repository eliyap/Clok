//
//  DateIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 14/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DateIndicator: View {
    
    @EnvironmentObject var zero: ZeroDate
    
    let dayHeight: CGFloat
    
    var body: some View {
        HStack(spacing: .zero) {
            ScrollView {
                TimeIndicator(divisions: evenDivisions(for: dayHeight))
            }
            .opacity(0)
            .allowsHitTesting(false)
            ForEach(
                Array(stride(from: zero.start, to: zero.end, by: .day)),
                id: \.timeIntervalSince1970
            ) { midnight in
                /// short weekday and date labels
                VStack(spacing: .zero) {
                    Text(midnight.shortWeekday)
                        .font(.footnote)
                        .lineLimit(1)
                    DateLabel(for: midnight)
                        .font(.caption)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                .background(Color.clokBG)
                .transition(zero.slideOver)
            }
        }
        .frame(height: 50)
    }
    
    func HeaderLabel(for date: Date) -> some View {
        /// short weekday and date labels
        VStack(spacing: .zero) {
            Text(date.shortWeekday)
                .font(.footnote)
                .lineLimit(1)
            DateLabel(for: date)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.clokBG)
    }
    
    func DateLabel(for date: Date) -> Text {
        let df = DateFormatter()
        if Calendar.current.component(.day, from: date) == 1 {
            df.setLocalizedDateFormatFromTemplate("MMM")
            return Text(df.string(from: date)).bold()
        } else {
            df.setLocalizedDateFormatFromTemplate("dd")
            return Text(df.string(from: date))
        }
    }
}
