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
    
    /// define a unified way to access `name`
    var id: Int64 {
        switch self {
        case .project(let project):
            return project.id
        case .special(let special):
            return special.id
        case .lite(let lite):
            return lite.id
        }
    }
    
    
    
    // - TODO: define 'no description' special case for `name`
}
