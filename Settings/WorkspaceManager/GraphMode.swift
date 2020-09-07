//
//  GraphMode.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Graph Mode
    private static let graphModeKey = "graphMode"
    /**
     what mode our `GraphView` is in
     */
    static var graphMode: Int {
        get {
            suite?.object(forKey: graphModeKey) as? Int
                /// default index of 0
                ?? GraphModel.Mode.calendar.rawValue
        }
        set {
            suite?.set(newValue, forKey: graphModeKey)
        }
    }
}
