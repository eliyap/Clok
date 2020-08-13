//
//  StatDisplayView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI



struct StatDisplayView: View {
    
    @EnvironmentObject var zero: ZeroDate
    private let df = DateFormatter()
    
    private var avgStart = placeholderTime
    private var avgEnd = placeholderTime
    private var avgDur = TimeInterval.zero
    
    private var deltaStart = TimeInterval.zero
    private var deltaEnd = TimeInterval.zero
    private var deltaAvgDur = TimeInterval.zero
    
    @Environment(\.colorScheme) var mode
    
    var body: some View {
        Group {
            WeekStats
            Divider()
            Text("Since Previous Week")
                .font(.headline)
                .bold()
            WeekChangeStats
        }
        
    }
    
    var WeekStats: some View {
        Group {
            Stat(
                label: "Started Around",
                symbol: "sun.dust.fill",
                text: Text(avgStart)
            )
            Stat(
                label: "Ended Around",
                symbol: "moon.stars.fill",
                text: Text(avgEnd)
            )
            Stat(
                label: "Hours Logged",
                symbol: "hourglass.tophalf.fill",
                text: Text((avgDur*7).toString())
            )
            Stat(
                label: "Per Day",
                symbol: nil,
                text: Text(avgDur.toString())
            )
                /// good ol negative padding hack to bring it closer up
                .padding(.top, -10)
            Stat(
                label: "Percentage of Week",
                symbol: "chart.pie.fill",
                text: Text("\(Int((avgDur / .day) * 100.0))%")
            )
        }
    }
    
    var WeekChangeStats: some View {
        Group {
            Stat(
                label: "Started",
                symbol: (deltaStart > 0 ? "forward" : "backward") + ".end.fill",
                text: Text(abs(deltaStart).toString() + " " + (deltaStart > 0 ? "later" : "earlier"))
            )
            Stat(
                label: "Ended",
                symbol: (deltaStart > 0 ? "forward" : "backward") + ".end.fill",
                text: Text(abs(deltaEnd).toString() + " " + (deltaStart > 0 ? "later" : "earlier"))
            )
            Stat(
                label: "\(deltaAvgDur > 0 ? "Increased" : "Decreased")",
                symbol: "arrow.\(deltaAvgDur > 0 ? "up" : "down").right",
                text: Text(abs(deltaAvgDur * 7).toString()),
                weight: .heavy
            )
            Stat(
                label: "Per Day",
                symbol: nil,
                text: Text(abs(deltaAvgDur).toString())
            )
                /// good ol negative padding hack to bring it closer up
                .padding(.top, -10)
        }
    }
    
    init(for week: WeekTimeFrame, prev: WeekTimeFrame) {
        df.timeStyle = .short
        df.dateStyle = .none
        
        /// handle cases where there are no entries
        if let start = week.avgStartTime() {
            avgStart = df.string(from: start)
            if let prevStart = prev.avgStartTime() {
                deltaStart = start - prevStart
            }
        }
        
        if let end = week.avgEndTime() {
            avgEnd = df.string(from: end)
            if let prevEnd = prev.avgEndTime() {
                deltaEnd = end - prevEnd
            }
        }
        
        avgDur = week.avgDuration()
        deltaAvgDur = prev.avgDuration() - avgDur
    }
    
    private let size = CGFloat(30)
    func Stat(label: String, symbol: String?, text: Text, weight: Font.Weight = .regular) -> some View {
        HStack{
            Image(systemName: symbol ?? "circle.fill")
                .foregroundColor(symbol == nil ? .clokBG : .primary)
                .font(Font.body.weight(weight))
                /// hardcoded size until Label is fixed
                .frame(width: size, height: size)
            Text(label)
            Spacer()
            text
        }
    }
}
