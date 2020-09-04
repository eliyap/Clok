//
//  Summary.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct RawSummary: Decodable {
    
    let data: [Project]
    let total_grand: Int /// total number of milliseconds
    
    struct Project: Decodable {
        let id: Int?
        let items: [Entry]
        let time: Int /// number of milliseconds for this project
        let title: RawSummaryProjectTitle
        
        struct RawSummaryProjectTitle: Decodable {
            let hex_color: String?
            let project: String?
        }
    }
    
    struct Entry: Decodable {
        let time: Int /// number of milliseconds for this entry
        let title: RawSummaryEntryTitle
        
        struct RawSummaryEntryTitle: Decodable {
            let time_entry: String
        }
    }
}

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
            id = raw.id ?? NSNotFound
            name = raw.title.project ?? "No Project"
            duration = TimeInterval(raw.time) / 1000.0
            switch raw.title.hex_color {
            case .none:
                color = Color.noProject
            case let .some(hex):
                color = Color(hex: hex)
            }
            entries = raw.items.map { Summary.Entry(from: $0) }
        }
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
