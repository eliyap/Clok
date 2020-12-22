//
//  RunningTimer.swift
//  RunningRingExtension
//
//  Created by Secret Asian Man Dev on 22/10/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WidgetManager {
    //MARK:- Running Timer
    private static let runningKey = "ClokWidgets.RunningTimer"
    /// currently running timer information
    static var running: RunningEntry {
        get {
            guard let decoded = suite?.object(forKey: runningKey) as? Data else {
                /// NOTE: on first start up, the storage has not yet been created, so this will fail.
                return .noEntry
            }
            do {
                return try JSONDecoder().decode(RunningEntry.self, from: decoded)
            } catch {
                #if DEBUG
                assert(false, "Unable to decode RunningEntry!")
                #endif
                return .noEntry
            }
        }
        set {
            suite?.setValue(
                try! JSONEncoder().encode(newValue),
                forKey: runningKey
            )
        }
    }
}
