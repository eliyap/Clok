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
}
