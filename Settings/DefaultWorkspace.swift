//
//  DefaultWorkspace.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation


/**
 since workspace IDs can be derived from credentials,
 and do not by themselves grant access to sensitive data,
 and since they are lightweight integers
 we do not store them in the keychain, instead in the User Defaults area
 */
struct WorkspaceManager {
    static let spacesKey = "Clok.WorkspaceIDs"
    static let spaceChosenKey = "Clok.ChosenID"
    
    static let suiteName = "group.sam.clok"
    
    static let suite = UserDefaults(suiteName: suiteName)
    
    static func saveSpaces(_ spaces: [Workspace]) -> Void {
        try! suite?.setValue(
            NSKeyedArchiver.archivedData(
                withRootObject: spaces,
                requiringSecureCoding: false
            ),
            forKey: spacesKey
        )
    }

    /// get user's stored `Workspace`s
    static func getSpaces() -> [Workspace]? {
        guard let decoded = suite?.object(forKey: spacesKey) as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Workspace.self], from: decoded) as? [Workspace]
    }

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
    
    static let firstDayOfWeekKey = "firstDayOfWeek"
    /**
     user's chosen firstDayOfWeek
     defaults to Sunday = 1
     */
    static var firstDayOfWeek: Int {
        get {
            suite?.object(forKey: firstDayOfWeekKey) as? Int ?? 1
        }
        set {
            suite?.set(newValue, forKey: firstDayOfWeekKey)
        }
    }
}
