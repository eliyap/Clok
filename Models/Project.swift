//
//  Project.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Project: Hashable, Comparable, Identifiable {
    var name: String
    var color: Color
    var id: Int
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        /// all projects are equal to Any Project
        if lhs.id == Project.any.id || rhs.id == Project.any.id { return true }
        else { return lhs.id == rhs.id }
    }
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        /// No Project should always be first
        if lhs == .noProject { return true }
        if rhs == .noProject { return false }
        return lhs.name < rhs.name
    }
    
    static let noProject = Project(
        name: "No Project",
        color: Color.noProject,
        id: NSNotFound
    )
    
    static let any = Project(
        name: "Any Project",
        color: Color.black.opacity(0.0),
        id: Int.zero
    )
}
