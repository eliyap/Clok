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
    
    /// a shared DF with this common template
    static let MMMdd = DateFormatter(template: "MMMdd")
}

extension Date {
    var MMMdd: String { DateFormatter.MMMdd.string(from: self) }
}
