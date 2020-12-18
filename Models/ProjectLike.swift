//
//  ProjectLike.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

/** *Technical History*
 After numerous searches and some pain, I found
 https://stackoverflow.com/questions/55996678/associated-protocol-in-swift
 What I want is an `associatedprotocol`. to tie into `TimeEntry` and `RunningTimeEntry` .
 Such a thing does not exist.
 Next closest thing is an `enum`.
 */

import Foundation
import SwiftUI

/// Defines a concrete type (not a `Protocol`) which may contain
///     - a `Project`
///     - some special case item which is defined in code
enum ProjectLike {
    case project(Project)
    case special(StaticProject)
    case lite(ProjectLite)
    
    /// define a unified way to access `color`
    var color: Color {
        switch self {
        case .project(let project):
            return project.wrappedColor
        case .special(let special):
            return special.color
        case .lite(let lite):
            return lite.color
        }
    }
    
    /// define a unified way to access `name`
    var name: String {
        switch self {
        case .project(let project):
            return project.name
        case .special(let special):
            return special.name
        case .lite(let lite):
            return lite.name
        }
    }
    
    // - TODO: define 'no description' special case for `name`
}

/// Defines a lightweight structure useful for conveying some `Project` attributes without
/// spawning a full fledged `CoreData` object.
/// Distinct from `StaticProject` so as to avoid confusion.
struct ProjectLite {
    let color: Color
    let name: String
    let id: Int64
}

/// Defines an edge case / special type of `Project` which I need to be able to refer to in code.
/// - Warning: do NOT instantiate!
struct StaticProject {
    let color: Color
    let name: String
    let id: Int64
    
    fileprivate init(
        id: Int64,
        hex_color: String,
        name: String
    ) {
        self.id = id
        self.color = Color(hex: hex_color)
        self.name = name
    }
}

extension StaticProject {
    /** Represents the valid state in a `TimeEntry`: having no `Project` selected.
     Though this might be represented by a `nil` value, the state has associated strings and colors,
     so I chose to design it as a specific state.
     */
    static let NoProject = StaticProject(
        id: Int64(NSNotFound),
        hex_color: Constants.NoProjectHex,
        name: "[No Project]"
    )
    
    /// Represents a state, mostly used in filters, that matches any project compared to it.
    static let AnyProject = StaticProject(
        id: Int64(WAIT_ANY), /// random unique named number
        hex_color: Constants.NoProjectHex,
        name: "[Any Project]"
    )
    
    /** Represents a failure to identify some `Project`.
     Usually this represents a state wherein a `Project` could not be found in our CoreData `Project` records,
     or the records could not be accessed, preventing the `Project` from being identified.
     */
    static let UnknownProject = StaticProject(
        id: Int64(kUnknownType), /// random unique named number
        hex_color: Constants.NoProjectHex,
        name: "[Unknown]"
    )
}
