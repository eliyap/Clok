//
//  DateFormatterShared.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension DateFormatter {
    /// init with template
    convenience init(template: String) {
        self.init()
        self.setLocalizedDateFormatFromTemplate(template)
    }
    
    /// init with template
    convenience init(timeStyle: Style = .none, dateStyle: Style = .none) {
        self.init()
        self.timeStyle = timeStyle
        self.dateStyle = dateStyle
    }
    
    /// a shared DF with this common template
    static let MMMdd = DateFormatter(template: "MMMdd")
    static let tfShort = DateFormatter(timeStyle: .short)
    static let dftfShort = DateFormatter(timeStyle: .short, dateStyle: .short)
    
    static var iso8601seconds: DateFormatter {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("yyyy-MM-dd'T'HH:mm:ss.SSS")
        return df
    }
}

extension Date {
    var MMMdd: String { DateFormatter.MMMdd.string(from: self) }
    var tfShort: String { DateFormatter.tfShort.string(from: self) }
    var dftfShort: String { DateFormatter.dftfShort.string(from: self) }
    var iso8601seconds: String { DateFormatter.iso8601seconds.string(from: self) }
}
