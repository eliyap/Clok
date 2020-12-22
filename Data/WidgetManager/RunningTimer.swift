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
    static var running: RunningEntry? {
        get {
            guard let decoded = suite?.object(forKey: runningKey) as? Data else {
                return nil
            }
            do {
                return try NSKeyedUnarchiver.unarchivedObject(
                    ofClasses: [RunningEntry.self, NSDate.self, NSString.self, NSArray.self],
                    from: decoded
                ) as? RunningEntry
            } catch {
                #if DEBUG
                assert(false, "Unable to decode RunningEntry!")
                #endif
                return nil
            }
            
        }
        set {
            guard let running = newValue else { return }
            try! suite?.setValue(
                NSKeyedArchiver.archivedData(
                    withRootObject: running,
                    requiringSecureCoding: false
                ),
                forKey: runningKey
            )
        }
    }
}
