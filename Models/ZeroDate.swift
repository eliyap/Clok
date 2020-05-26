//
//  ZeroDate.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

class ZeroDate: ObservableObject {
    let pastSeven = WeekTimeFrame()
    let thisWeek = WeekTimeFrame(
        starts: Weekdays.Monday.rawValue,
        contains: Date()
    )
    let lastWeek = WeekTimeFrame(preceding: WeekTimeFrame(
        starts: Weekdays.Monday.rawValue,
        contains: Date()
    ))
    
    // represents what time frame is shown
    enum frameState {
        case pastSeven
        case thisWeek
        case lastWeek
        // any other past week
        case distantPast
    }
    
    func frameState() -> frameState {
        if frame == pastSeven { return .pastSeven }
        if frame == thisWeek { return .thisWeek }
        if frame == lastWeek { return .lastWeek }
        return .distantPast
    }
    
    // default to 1 week before end of today
    @Published var frame = WeekTimeFrame(
        starts: Weekdays.Monday.rawValue,
        contains: Date()
    )
}
