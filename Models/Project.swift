//
//  Project.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

protocol ProjectLike {
    var wrappedID: Int { get }
    var wrappedColor: Color { get }
    var wrappedName: String { get }
    func matches(_ other: ProjectLike) -> Bool
}

class StaticProject: ProjectLike {
    
    var wrappedID: Int
    var wrappedColor: Color
    var wrappedName: String
    
    static func == (lhs: StaticProject, rhs: ProjectLike) -> Bool {
        lhs.wrappedName == rhs.wrappedName && lhs.wrappedID == rhs.wrappedID
    }
    
    func matches(_ other: ProjectLike) -> Bool {
        /// Any Project matches all other projects
        self == other || StaticProject.any == other  || self == StaticProject.any
    }
    
    static func < (lhs: StaticProject, rhs: ProjectLike) -> Bool {
        /// No Project should always be first
        if StaticProject.noProject == lhs  { return true }
        if StaticProject.noProject == rhs  { return false }
        return lhs.wrappedName < rhs.wrappedName
    }
    
    init(name: String, color: Color, id: Int){
        wrappedName = name
        wrappedID = id
        wrappedColor = color
    }
    
    static let noProject = StaticProject(
        name: "No Project",
        color: Color.noProject,
        id: NSNotFound
    )

    /// should not appear, represents a project that could not be fetched from our data base
    static let unknown = StaticProject(
        name: "Unknown Project",
        color: Color.noProject,
        id: NSNotFound
    )
    
    static let any = StaticProject(
        name: "Any Project",
        color: Color.secondary,
        id: Int.zero
    )
}
