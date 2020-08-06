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
    /// default to 1 week before start of today
    @Published var start = Calendar.current.startOfDay(for: Date()) - weekLength
    
    /// computed end date
    var end: Date {
        start + Double(dayCount) * dayLength
    }
    
    /// number of days displayed
    @Published var dayCount = 7
    /// min / max number of days displayed on a graph
    /// NOTE: modified based on whether app is iPhone or iPad
    var countMax = 31
    let countMin = 7
    
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
    @Published var interval: TimeInterval = dayLength / 3
    var zoom: CGFloat {
        CGFloat(dayLength / interval)
    }
}
