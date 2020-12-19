//
//  DateComponent.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 20/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/**
 I'm so sick of getting components this way
 */
extension Date {
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var midnight: Date {
        Calendar.current.startOfDay(for: self)
    }
    var iso8601day: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
        return df.string(from: self)
    }
    var ISO8601: String {
        ISO8601DateFormatter().string(from: self)
    }
}
