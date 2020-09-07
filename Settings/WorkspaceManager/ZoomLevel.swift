//
//  ZoomLevel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Bar Zoom Level
    private static let zoomKey = "barZoomLevel"
    /**
     how much to scale (or zoom) the `GraphView`
     */
    static var zoomIdx: Int {
        get {
            suite?.object(forKey: zoomKey) as? Int
                /// default index of 0
                ?? 0
        }
        set {
            suite?.set(newValue, forKey: zoomKey)
        }
    }
}
