//
//  RawProject.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// simplify decoding
/// Documentation:
/// https://github.com/toggl/toggl_api_docs/blob/f62b8f4bb9118d97af54df48a268ff1e4319b34b/chapters/projects.md#projects
struct RawProject: Decodable {
    let id: Int
    let is_private: Bool
    let wid: Int
    let hex_color: String
    let name: String
    let billable: Bool
    
    /// `Date` the "task" was last updated
    let at: Date
    // one of these cases a coding failure, ignore for now
//        var actual_hours: Int
//        var color: Int // probably an enum for toggl's default color palette
}

//MARK:- RawProject Presets
extension RawProject {
    
    /** Represents the valid state in a `TimeEntry`: having no `Project` selected.
     Though this might be represented by a `nil` value, the state has associated strings and colors,
     so I chose to design it as a specific state.
     */
    static let NoProject = RawProject(
        id: NSNotFound,
        is_private: false, /// inconsequential
        wid: -1, /// placeholder value
        hex_color: Constants.NoProjectHex,
        name: "[No Project]",
        billable: false, /// inconsequential
        at: .distantPast
    )
    
    /// Represents a state, mostly used in filters, that matches any project compared to it.
    static let AnyProject = RawProject(
        id: NSNotFound,
        is_private: false, /// inconsequential
        wid: -1, /// placeholder value
        hex_color: Constants.NoProjectHex,
        name: "[Any Project]",
        billable: false, /// inconsequential
        at: .distantPast
   )
    
    
    /** Represents a failure to identify some `Project`.
     Usually this represents a state wherein a `Project` could not be found in our CoreData `Project` records,
     or the records could not be accessed, preventing the `Project` from being identified.
     */
    static let UnknownProject = RawProject(
        id: NSNotFound,
        is_private: false, /// inconsequential
        wid: -1, /// placeholder value
        hex_color: Constants.NoProjectHex,
        name: "[Unknown]",
        billable: false, /// inconsequential
        at: .distantPast
    )
}
