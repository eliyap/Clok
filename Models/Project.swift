//
//  Project.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Project: Hashable, Comparable {
    var name: String
    var color: Color
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs.name < rhs.name
    }
    
    static let noProject = Project(
        name: "No Project",
        color: Color.noProject
    )
}
