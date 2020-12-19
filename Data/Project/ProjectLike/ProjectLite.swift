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
