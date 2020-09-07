//
//  Keys.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- All Workspaces
    private static let spacesKey = "Clok.WorkspaceIDs"
    /// user's stored `Workspace`s
    static var workspaces: [Workspace]? {
        get {
            guard let decoded = suite?.object(forKey: spacesKey) as? Data else { return nil }
            return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Workspace.self], from: decoded) as? [Workspace]
        }
        set {
            guard let workspaces = newValue else { return }
            try! suite?.setValue(
                NSKeyedArchiver.archivedData(
                    withRootObject: workspaces,
                    requiringSecureCoding: false
                ),
                forKey: spacesKey
            )
        }
    }
    
    // MARK:- Chosen Workspace
    private static let spaceChosenKey = "Clok.ChosenID"
    /// user's chosen `Workspace`
    static var chosenWorkspace: Workspace? {
        get {
            guard let decoded  = suite?.object(forKey: spaceChosenKey) as? Data else { return nil }
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Workspace.self, from: decoded)
        }
        set {
            guard let workspace = newValue else { return }
            try! suite?.setValue(
                NSKeyedArchiver.archivedData(
                    withRootObject: workspace,
                    requiringSecureCoding: false
                ),
                forKey: spaceChosenKey
            )
        }
    }
    
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
