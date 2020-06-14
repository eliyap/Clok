//
//  DateBar.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.24.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

enum weekLabels : String {
    case current = "This Week"
    case pastSeven = "Last 7 Days"
    case last = "Last Week"
    case next = "Next"
    case prev = "Prev"
}

/// click to roll back to the previous week
struct prevWeekButton : View {
    @EnvironmentObject private var zero:ZeroDate
    
    var body : some View {
        /// logic for "previous" week
        Button(action: {
            switch self.zero.frameState() {
            case .thisWeek:
                self.zero.frame = self.zero.pastSeven
            case .pastSeven:
                self.zero.frame = self.zero.lastWeek
            default:
                self.zero.frame = WeekTimeFrame(preceding: self.zero.frame)
            }
        }) {
            ZStack{
                Image(systemName: "chevron.left")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(
                Circle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color(UIColor.systemBackground).opacity(0.7), radius: 10, x: -5, y: -5)
            )
            .border(Color.red)
        }
    }
}

/// click to roll forwards to the next week
struct nextWeekButton : View {
    @EnvironmentObject private var zero:ZeroDate
    @Environment(\.verticalSizeClass) var vSize
    
    var body : some View {
        /// logic for "next" week
        Button(action: {
            switch self.zero.frameState() {
            case .thisWeek:
                fatalError() /// should be disabled
            case .pastSeven:
                self.zero.frame = self.zero.thisWeek
            case .lastWeek:
                self.zero.frame = self.zero.pastSeven
            default:
                self.zero.frame = WeekTimeFrame(succeeding: self.zero.frame)
            }
        }) {
            ZStack{
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(
                Circle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color(UIColor.systemBackground).opacity(0.7), radius: 10, x: -5, y: -5)
            )
            .border(Color.red)
        }
        // do not allow clicks when in the This Week time frame
        .disabled(self.zero.frame == self.zero.thisWeek)
        // go translucent when disabled
        .opacity(self.zero.frame == self.zero.thisWeek ? 0.5 : 1)
    }
}
