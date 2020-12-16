//
//  FirstDayOfWeek.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WidgetManager {
    // MARK:- Weekday
    private static let firstDayOfWeekKey = "ClokWidgets.FirstDayOfWeek"
    /**
     user's chosen firstDayOfWeek
     */
    static var firstDayOfWeek: Int {
        get {
            suite?.object(forKey: firstDayOfWeekKey) as? Int
            ?? 1 /// defaults to sunday if not set. bad practice
        }
        set {
            suite?.set(newValue, forKey: firstDayOfWeekKey)
        }
    }
}

