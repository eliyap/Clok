//
//  RunningNotification.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Running TimeEntry UserNotification UUID
    private static let runningNotificationKey = "Clok.RunningNotification"
    
    static var RunningUUID: String? {
        get {
            suite?.string(forKey: Self.runningNotificationKey)
        }
        set {
            suite?.set(newValue, forKey: Self.runningNotificationKey)
        }
    }
}
