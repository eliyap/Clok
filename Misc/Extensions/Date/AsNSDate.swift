//
//  DateAsNSDate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension NSDate {
    convenience init(_ date: Date) {
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}
