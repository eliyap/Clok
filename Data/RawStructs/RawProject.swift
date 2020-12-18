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
