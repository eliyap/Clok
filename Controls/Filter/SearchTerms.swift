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
}
