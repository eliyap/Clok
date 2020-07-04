//
//  get24hour.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
/// determine whether the user's phone is set to 24 hour time
/// true if 24 hour time, false if AM/PM time
/// https://stackoverflow.com/questions/28162729/nsdateformatter-detect-24-hour-clock-in-os-x-and-ios
func is24hour() -> Bool {
    let locale = NSLocale.current
    /// no idea why this works, but works as of July 2020
    let amFlag = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
    /// flag is "HH" for 24 hour time
    /// and "h a" for 12 hour time
    return amFlag.firstIndex(of: "a") == nil
}
