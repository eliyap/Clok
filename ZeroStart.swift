//
//  ZeroStart.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Zero Start Date
    private static let startKey = "zeroStart"
    static var zeroStart: Date {
        get {
            suite?.object(forKey: startKey) as? Date
                /// default index of 0
                ?? Date()
        }
        set {
            suite?.set(newValue, forKey: startKey)
        }
    }
}
