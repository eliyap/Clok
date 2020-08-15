//
//  TimeIntervalExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toString() -> String {
        guard !self.isNaN else {
            return placeholderTime
        }
        let seconds = Int(self)
        let hh:Int = seconds / 3600
        let mm:Int = (seconds % 3600) / 60
        let ss:Int = seconds % 60
        return String(format: "%d:%02d:%02d", hh,mm,ss)
    }
}

extension TimeInterval {
    static let hour: TimeInterval = 60.0 * 60.0
    static let day: TimeInterval = 24 * hour
    static let week: TimeInterval = 7 * day
}
