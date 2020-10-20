//
//  Summary.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Summary: Decodable {
    
    let total: TimeInterval
    let projects: [Summary.Project]
    
    struct Project {
        let id: Int
        let entries: [Summary.Entry]
        let color: Color
        let name: String
        let duration: TimeInterval
        
        init(from raw: RawSummary.Project) {
            id = raw.id ?? Summary.Project.empty.id
            name = raw.title.project ?? Summary.Project.empty.name
            duration = TimeInterval(raw.time) / 1000.0
            switch raw.title.hex_color {
            case .none:
                color = Color.noProject
            case let .some(hex):
                color = Color(hex: hex)
            }
            entries = raw.items.map {
                Summary.Entry(from: $0)
            }
        }
        
        fileprivate init(id: Int, color: Color, name: String, duration: TimeInterval){
            self.id = id
            entries = []
            self.color = color
            self.name = name
            self.duration = duration
        }
        
        static let empty = Summary.Project(id: NSNotFound, color: .clear, name: "No Project", duration: .zero)
        static let placeholder_1 = Summary.Project(id: -1, color: .red, name: "Work", duration: .hour)
    }
    
    struct Entry {
        let description: String
        let duration: TimeInterval
        init(from raw: RawSummary.Entry) {
            description = raw.title.time_entry
            duration = TimeInterval(raw.time) / 1000.0
        }
    }
    
    init(from decoder: Decoder) throws {
        let rawSummary = try RawSummary(from: decoder)
        /// convert to seconds
        total = TimeInterval(rawSummary.total_grand) / 1000.0
        projects = rawSummary.data.map{ Summary.Project(from: $0) }
    }
}
