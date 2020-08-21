//
//  RunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct RunningEntry: Equatable {

    let id: Int
    var pid: Int = NSNotFound
    let start: Date
    var project: ProjectLike
    let description: String
    let df = DateFormatter()
    
    private init(id: Int, start: Date, project: ProjectLike, description: String){
        self.id = id
        self.start = start
        self.project = project
        self.description = description
    }
    
    
    
    // parse from JSON for Widget
    init?(from data: [String : AnyObject], project: ProjectLike){
        // initialize DateFormatter to handle ISO8601 strings
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        // check that these properties are not nil
        guard
            let id = data["id"] as? Int,
            data["description"] != nil,
            let description = data["description"] as? String,
            // get Dates from ISO8601 string
            data["start"] != nil,
            let startString = data["start"] as? String,
            let start = df.date(from: startString)
        else { return nil }
        
        self.id = id
        self.description = description
        self.start = start
        self.project = project
    }
    
    /// Headlining description,
    /// or project if there's no description,
    /// or placeholder if no info whatsoever
    func descriptionString() -> String {
        if description == "" && StaticProject.noProject == project {
            return "No Description"
        } else if description == "" {
            return project.name
        } else {
            return description
        }
    }

    static func == (lhs: RunningEntry, rhs: RunningEntry) -> Bool {
        /// we could check everything, but unless the data is corrupted we really only need to check task ID
        /// NOTE: if in future we support editing of time entries, this check will need to be more rigorous
        return
            lhs.id == rhs.id &&
            lhs.start == rhs.start &&
            lhs.description == rhs.description
       }
}

extension RunningEntry {
    /// signals that no entry is currently running
    static let noEntry = RunningEntry(
        id: NSNotFound,
        start: Date.distantFuture,
        project: StaticProject.noProject,
        description: "No Entry Running"
    )
}
