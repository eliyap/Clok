//
//  DateBar.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.24.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DateBar: View {
    @EnvironmentObject private var zero:ZeroDate
    private let df = DateFormatter()
    
    @State var prevLabel = "Last Week"
    @State var nextLabel = "Past 7 Days"
    
    // Order of weeks: This Calendar Week, Past 7 Days, Last Week, etc...
    
    enum weeks: String {
        case current = "This Week"
        case pastSeven = "Past 7 Days"
        case last = "Last Week"
        case next = "Next"
        case prev = "Previous"
    }
    
    var body: some View {
        HStack {
            Spacer()
            // previous week button
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
                    Text(
                        // poor man's switch statement
                        self.zero.frame == self.zero.thisWeek ?
                        weeks.pastSeven.rawValue :
                        self.zero.frame == self.zero.pastSeven ?
                        weeks.last.rawValue :
                        weeks.prev.rawValue
                    )
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Text(
                // poor man's switch statement
                self.zero.frame == self.zero.pastSeven ?
                weeks.pastSeven.rawValue :
                self.zero.frame == self.zero.thisWeek ?
                weeks.current.rawValue :
                self.zero.frame == self.zero.lastWeek ?
                weeks.last.rawValue :
                df.string(from: zero.frame.start) + " – " + df.string(from: zero.frame.end))
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                switch self.zero.frameState() {
                case .thisWeek:
                    return // SHOULD BE DISABLED
                case .pastSeven:
                    self.zero.frame = self.zero.thisWeek
                case .lastWeek:
                    self.zero.frame = self.zero.pastSeven
                default:
                    self.zero.frame = WeekTimeFrame(succeeding: self.zero.frame)
                }
            }) {
                HStack {
                    Text(
                        // poor man's switch statement
                        self.zero.frame == self.zero.thisWeek ?
                        "Future" :
                        self.zero.frame == self.zero.pastSeven ?
                        weeks.current.rawValue :
                        self.zero.frame == self.zero.lastWeek ?
                        weeks.pastSeven.rawValue :
                        weeks.next.rawValue
                    )
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            // do not allow clicks when in the This Week time frame
            .disabled(self.zero.frame == self.zero.thisWeek)
            // go translucent when disabled
            .opacity(self.zero.frame == self.zero.thisWeek ? 0.5 : 1)
            Spacer()
        }
    }
    
    init() {
        // using method from
        // https://stackoverflow.com/questions/51267284/ios-swift-how-to-have-dateformatter-without-year-for-any-locale
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
}

struct DateBar_Previews: PreviewProvider {
    static var previews: some View {
        DateBar()
    }
}
