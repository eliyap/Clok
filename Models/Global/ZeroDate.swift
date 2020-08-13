//
//  ZeroDate.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

final class ZeroDate: ObservableObject {
    init(start: Date){
        self.start = start
    }
    
    /// default to 6 days before start of today
    /// ensures the default week includes today
    @Published var start: Date
    
    /// computed end date
    var end: Date {
        start + .week
    }
    
    /// whether the date was moved forwards of backwards
    enum DateChange {
        case fwrd
        case back
    }
    
    @Published var dateChange : DateChange? = nil
    
    /// whether the time indicating clock hands should be on screen
    @Published var showTime = false
    
    /// length of time interval being examined
    /// defaults to 8 hours
    @Published var interval: TimeInterval = .day
    var zoom: CGFloat {
        CGFloat(TimeInterval.day / interval)
    }
}

extension ZeroDate {
    var weekString: String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMdd")
        /// slightly adjust end down so it falls before midnight into the previous day
        return "\(df.string(from: start)) – \(df.string(from: end - 1))"
    }
}
