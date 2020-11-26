//
//  Detailed.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct Detailed: Decodable {
    
    let total: TimeInterval
//    let projects: [Detailed.Project]
    
    init(from decoder: Decoder) throws {
        let rawSummary = try RawSummary(from: decoder)
        /// convert to seconds
        total = TimeInterval(rawSummary.total_grand) / 1000.0
//        projects = rawSummary.data.map{ Summary.Project(from: $0) }
    }
}
