//
//  Workspaces.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
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
}
