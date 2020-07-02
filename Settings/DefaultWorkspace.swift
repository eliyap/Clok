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
    
    static func saveIDs(_ ids: [Int]) -> Void {
        WorkspaceManager.defaults.setValue(ids, forKey: WorkspaceManager.spacesKey)
    }

    static func saveChosen(id: Int) -> Void {
        WorkspaceManager.defaults.setValue(id, forKey: WorkspaceManager.spaceChosenKey)
    }
    
    static func getIDs() -> [Int]? {
        WorkspaceManager.defaults.object(forKey: WorkspaceManager.spacesKey) as? [Int]
    }

    // the value UserDefaults returns if nothing was found
    static let defaultInt = 0
    static func getChosen() -> Int? {
        let id = WorkspaceManager.defaults.integer(forKey: WorkspaceManager.spaceChosenKey)
        guard id != 0 else {
            return nil
        }
        return id
    }
}
