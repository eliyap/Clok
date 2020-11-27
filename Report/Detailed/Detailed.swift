//
//  Detailed.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Detailed: Decodable {
    
    let total: TimeInterval
    
    /// initialize with `noProject`
    var projects: [Detailed.Project:[Detailed.Entry]] = [Detailed.Project.noProject:[]]
    
    init(from decoder: Decoder) throws {
        let rawDetailed = try RawDetailed(from: decoder)
        
        /// convert total time from ms to seconds
        total = TimeInterval(rawDetailed.total_grand) / 1000.0
        
        /// assemble dictionary
        rawDetailed.data.forEach{ raw in
            let (project, entry) = split(entry: raw)
            if projects.keys.contains(project){
                projects[project]?.append(entry)
            } else {
                projects[project] = [entry]
            }
        }
    }
}

// MARK:- Split
extension Detailed {
    /**
     Breaks the raw time entry into entry data and project data
     */
    func split(entry: RawTimeEntry) -> (Detailed.Project, Detailed.Entry){
        var project: Detailed.Project!
        switch entry.pid {
        case .none:
            project = Detailed.Project.noProject
        default:
            project = Detailed.Project(
                color: Color(hex: entry.project_hex_color
                    ?? StaticProject.unknown.wrappedColor.toHex
                ),
                name: entry.project
                    ?? StaticProject.unknown.name,
                id: entry.pid
                    ?? StaticProject.unknown.wrappedID
            )
        }
        return (project, Detailed.Entry(
            description: entry.description,
            start: entry.start,
            end: entry.end,
            dur: entry.dur / 1000.0, /// convert from ms to seconds
            id: entry.id,
            billable: entry.is_billable,
            tags: entry.tags
        ))
    }
}

// MARK:- Detailed Report Project
extension Detailed {
    struct Project: Hashable {
        let color: Color
        let name: String
        let id: Int
        
        /// copy from main app to keep consistency
        static let noProject = Detailed.Project(
            color: StaticProject.noProject.wrappedColor,
            name: StaticProject.noProject.name,
            id: StaticProject.noProject.wrappedID
        )
    }
}

// MARK:- Detailed Report Entry
extension Detailed {
    struct Entry: Hashable {
        let description: String
        
        let start: Date
        let end: Date
        let dur: Double
        
        let id: Int
        let billable: Bool
                
        let tags: [String]

        /// ignore this attributes
        // let updated: Date
        // let uid: Int; // user ID
        // let use_stop: Bool
        // let user: String
    }
}
