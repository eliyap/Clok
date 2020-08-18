//
//  DateAsNSDate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension Date {
    var asNSDate: NSDate {
        NSDate(timeIntervalSince1970: timeIntervalSince1970)
    }
}
