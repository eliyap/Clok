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
    @Published var zoomIdx: Int = 0
    var zoomLevel: CGFloat {
        zoomLevels[zoomIdx]
    }
    var interval: TimeInterval {
        .day / Double(zoomLevel)
    }
    
    let zoomLevels: [CGFloat] = [
        1.0, /// 24hr
        1.5, /// 16hr
        2.0, /// 12hr
        3.0, /// 8hr
        4.0, /// 6hr
        6.0, /// 4hr
        8.0, /// 3hr
        12.0,/// 2hr
        24.0 /// 1hr
    ]
}

extension ZeroDate {
    var weekString: String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMdd")
        /// slightly adjust end down so it falls before midnight into the previous day
        return "\(df.string(from: start)) – \(df.string(from: end - 1))"
    }
}
