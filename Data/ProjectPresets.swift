//
//  ProjectPresets.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

extension Project {
    /** Represents the valid state in a `TimeEntry`: having no `Project` selected.
     Though this might be represented by a `nil` value, the state has associated strings and colors,
     so I chose to design it as a specific state.
     */
    static func NoProject(childMOC moc: NSManagedObjectContext) -> Project {
       Project(raw: RawProject(
            id: NSNotFound,
            is_private: false, /// inconsequential
            wid: -1, /// placeholder value
            hex_color: Constants.NoProjectHex,
            name: "[No Project]",
            billable: false, /// inconsequential
            at: .distantPast
       ), context: moc)
    }
    
    static func AnyProject(childMOC moc: NSManagedObjectContext) -> Project {
       Project(raw: RawProject(
            id: NSNotFound,
            is_private: false, /// inconsequential
            wid: -1, /// placeholder value
            hex_color: Constants.NoProjectHex,
            name: "[Any Project]",
            billable: false, /// inconsequential
            at: .distantPast
       ), context: moc)
    }
    
    /** Represents a failure to identify some `Project`.
     Usually this represents a state wherein a `Project` could not be found in our CoreData `Project` records,
     or the records could not be accessed, preventing the `Project` from being identified.
     */
    static func UnknownProject(childMOC moc: NSManagedObjectContext) -> Project {
       Project(raw: RawProject(
            id: NSNotFound,
            is_private: false, /// inconsequential
            wid: -1, /// placeholder value
            hex_color: Constants.NoProjectHex,
            name: "[Unknown]",
            billable: false, /// inconsequential
            at: .distantPast
       ), context: moc)
    }
}

/// a collection of preset temporary `Project`s that can be created at will in any `NSManagedObjectContext`
struct ProjectPresets {
    
    let NoProject: Project
    let AnyProject: Project
    let UnknownProject: Project
    
    init(childMOC moc: NSManagedObjectContext) {
        NoProject = Project.NoProject(childMOC: moc)
        AnyProject = Project.AnyProject(childMOC: moc)
        UnknownProject = Project.UnknownProject(childMOC: moc)
    }
}
