//
//  SearchTerms.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct SearchTerms {
    enum Mode {
        case projects
        case tags
    }
    /// what to filter by
    /// currently, we support only Projects (and later, OR tags)
    var mode: Mode = .projects
    
    /// included projects (including `noProject`)
    var projects: [ProjectLike] = [StaticProject.any]
    
    var tags: [Any] {
        fatalError("Tag system not yet implemented")
    }
    
    func contains(project: ProjectLike) -> Bool {
        projects.contains(where: {project.wrappedID == $0.wrappedID})
    }
    
    /// sorting function for projects in BarGraph
    func projectSort(p0: ProjectLike, p1: ProjectLike) -> Bool {
        switch (contains(project: p0), contains(project: p1)) {
        /// case 1: prioritize the entry that is included
        case (false, true):
            return true
        case (true, false):
            return false
        /// case 2: neither are included: sort by name
        case (false, false):
            return p0.wrappedName < p1.wrappedName
        case (true, true):
            let index0 = projects.firstIndex(where: {$0.wrappedID == p0.wrappedID})!
            let index1 = projects.firstIndex(where: {$0.wrappedID == p1.wrappedID})!
            return index0 < index1
        }
        
    }
}
