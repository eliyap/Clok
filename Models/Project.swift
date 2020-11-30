//
//  Project.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/// a data type with the general shape of a `Project`
protocol ProjectLike {
    var wrappedID: Int { get }
    var wrappedColor: Color { get }
    var name: String { get }
    func matches(_ other: ProjectLike) -> Bool
}

class StaticProject: ProjectLike {
    
    var wrappedID: Int
    var wrappedColor: Color
    var name: String
    
    static func == (lhs: StaticProject, rhs: ProjectLike) -> Bool {
        lhs.name == rhs.name && lhs.wrappedID == rhs.wrappedID
    }
    
    func matches(_ other: ProjectLike) -> Bool {
        /// Any Project matches all other projects
        self == other || StaticProject.any == other  || self == StaticProject.any
    }
    
    static func < (lhs: StaticProject, rhs: ProjectLike) -> Bool {
        /// No Project should always be first
        if StaticProject.noProject == lhs  { return true }
        if StaticProject.noProject == rhs  { return false }
        return lhs.name < rhs.name
    }
    
    init(name: String, color: Color, id: Int){
        self.name = name
        wrappedID = id
        wrappedColor = color
    }
}

/**
 `StaticProject`s identify special project cases, and are not stored in Core Data
 */
extension StaticProject {
    
    static let all = [noProject, unknown, any]
    
    static let noProject = StaticProject(
        name: "[None]",
        color: Color.noProject,
        id: NSNotFound /// just a random named number
    )

    /// should not appear, represents a project that could not be fetched from our data base
    static let unknown = StaticProject(
        name: "Unknown Project",
        color: Color.noProject,
        id: NS_UnknownByteOrder /// just a random named number
    )
    
    static let any = StaticProject(
        name: "Any Project",
        color: Color.secondary,
        id: Int.zero
    )
}
