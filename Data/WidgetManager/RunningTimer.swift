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
                print("failed to decode")
                return nil
                
            }
            return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [RunningEntry.self, NSDate.self], from: decoded) as? RunningEntry
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
