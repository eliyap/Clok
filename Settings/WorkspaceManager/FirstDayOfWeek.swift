//
//  FirstDayOfWeek.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Weekday
    private static let firstDayOfWeekKey = "firstDayOfWeek"
    /**
     user's chosen firstDayOfWeek
     */
    static var firstDayOfWeek: Int {
        get {
            suite?.object(forKey: firstDayOfWeekKey) as? Int
                /// defaults to Sunday = 1
                ?? 1
        }
        set {
            suite?.set(newValue, forKey: firstDayOfWeekKey)
        }
    }
}
