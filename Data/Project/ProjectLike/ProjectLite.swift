//
//  ProjectLite.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// Defines a lightweight structure useful for conveying some `Project` attributes without
/// spawning a full fledged `CoreData` object.
/// Distinct from `StaticProject` so as to avoid confusion.
struct ProjectLite: Hashable {
    let color: Color
    let name: String
    let id: Int64
}

/// convinient copies of some special values
extension ProjectLite {
    static let NoProjectLite = ProjectLite(
        color: StaticProject.NoProject.color,
        name: StaticProject.NoProject.name,
        id: StaticProject.NoProject.id
    )
    
    static let UnknownProjectLite = ProjectLite(
        color: StaticProject.UnknownProject.color,
        name: StaticProject.UnknownProject.name,
        id: StaticProject.UnknownProject.id
    )
    
    static let AnyProjectLite = ProjectLite(
        color: StaticProject.AnyProject.color,
        name: StaticProject.AnyProject.name,
        id: StaticProject.AnyProject.id
    )
}
