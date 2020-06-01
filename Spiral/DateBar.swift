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
struct prevWeekBtn : View {
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
            HStack {
                Image(systemName: "chevron.left")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            /// increase the size of the touch target
            .padding()
        }
    }
}

/// click to roll forwards to the next week
struct nextWeekBtn : View {
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
                Circle()
                    .path(in: CGRect(x: 0, y: 0, width: 50, height: 50))
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        // do not allow clicks when in the This Week time frame
        .disabled(self.zero.frame == self.zero.thisWeek)
        // go translucent when disabled
        .opacity(self.zero.frame == self.zero.thisWeek ? 0.5 : 1)
    }
}
