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
    
    static let defaults = UserDefaults.standard
    
    static func saveSpaces(_ spaces: [Workspace]) -> Void {
        try! WorkspaceManager.defaults.setValue(
            NSKeyedArchiver.archivedData(
                withRootObject: spaces,
                requiringSecureCoding: false
            ),
            forKey: WorkspaceManager.spacesKey
        )
    }

    static func saveChosen(_ space: Workspace) -> Void {
        try! WorkspaceManager.defaults.setValue(
            NSKeyedArchiver.archivedData(
                withRootObject: space,
                requiringSecureCoding: false
            ),
            forKey: WorkspaceManager.spaceChosenKey
        )
    }
    
    // unarchive previously stored data objects
    static func getSpaces() -> [Workspace]? {
        let decoded  = WorkspaceManager.defaults.object(forKey: WorkspaceManager.spacesKey) as! Data
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Workspace.self], from: decoded) as? [Workspace]
    }

    
    static func getChosen() -> Workspace? {
        let decoded  = WorkspaceManager.defaults.object(forKey: WorkspaceManager.spaceChosenKey) as! Data
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: Workspace.self, from: decoded) as? Workspace
    }
}
