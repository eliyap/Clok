//
//  LastIndexedRepresentatives.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Date that TimeEntry Representatives were Last Indexed
    private static let lastIndexedRepresentativesKey = "Clok.Representatives"
    
    static var lastIndexedRepresentatives: Date {
        get {
            suite?.object(forKey: Self.lastIndexedRepresentativesKey) as? Date
                /// default index of 0
                ?? Date()
        }
        set {
            suite?.set(newValue, forKey: Self.lastIndexedRepresentativesKey)
        }
    }
}
