//
//  ZeroDate.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

final class ZeroDate: ObservableObject {
    // default to 1 week before end of today
    @Published var date = Date() - weekLength
    
    enum dateChange {
        case fwrd
        case back
    }
    
    @Published var weekSkip : dateChange? = nil
    
    /// whether the time indicating clock hands should be on screen
    @Published var showTime = false
    
    /// length of time interval being examined
    /// defaults to 8 hours
    @Published var interval: TimeInterval = dayLength / 3
}
