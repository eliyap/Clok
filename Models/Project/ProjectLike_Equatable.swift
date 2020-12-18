//
//  ProjectLike_Equatable.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension ProjectLike: Equatable {
    static func < (lhs: ProjectLike, rhs: ProjectLike) -> Bool {
        /// No Project should always be first
        if ProjectLike.special(.NoProject) == lhs  { return true }
        if ProjectLike.special(.NoProject) == rhs  { return false }
        return lhs.name < rhs.name
    }
    
    static func == (lhs: ProjectLike, rhs: ProjectLike) -> Bool {
        switch (lhs, rhs) {
        case (.project(let l), .project(let r)):
            return l == r
        
        /// since these  are known values, we can shortcut by comparing IDs
        case (.special(let l), .special(let r)):
            return l.id == r.id
        
        case (.lite(let l), .lite(let r)):
            return l == r
        
        /// NOTE: you may wish to match `ProjectLite` against `Project` at some point...
            
        /// fail any case with non-matched associated types
        default:
            return false
        }
    }
}
