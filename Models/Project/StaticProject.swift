//
//  StaticProject.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

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
    
    static let all = [NoProject, AnyProject, UnknownProject]
    
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
