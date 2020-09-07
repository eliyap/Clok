//
//  SearchTermsProjects.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension WorkspaceManager {
    // MARK:- Search Terms Projects
    private static let termsProjectsKey = "termsProjects"
    /**
     stores the `Project` ID's user was searching for
     */
    static var termsProjects: [Int] {
        get {
            suite?.object(forKey: termsProjectsKey) as? [Int]
                /// default no projects
                ?? []
        }
        set {
            suite?.set(newValue, forKey: termsProjectsKey)
        }
    }
}
