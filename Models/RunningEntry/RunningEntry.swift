//
//  RunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

final class RunningEntry: NSObject {
    
    var id: Int64
    var pid: Int64?
    var start: Date
    var project: ProjectLike
    var entryDescription: String
    var tags: [String] = []
    var billable: Bool
    
    let df = DateFormatter()
    
    init(
        id: Int64,
        start: Date,
        project: Project?,
        entryDescription: String,
        tags: [String]?,
        billable: Bool
    ){
        self.id = id
        self.start = start
        self.project = project
        self.pid = project?.id
        self.entryDescription = entryDescription
        self.tags = tags ?? []
        self.billable = billable
    }
        
    static func == (lhs: RunningEntry, rhs: RunningEntry) -> Bool {
        /// we could check everything, but unless the data is corrupted we really only need to check task ID
        /// NOTE: if in future we support editing of time entries, this check will need to be more rigorous
        return
            lhs.id == rhs.id &&
            lhs.start == rhs.start &&
            lhs.entryDescription == rhs.entryDescription &&
            /// perform a shallow Project ID check
            lhs.pid == rhs.pid
       }
}

extension RunningEntry {
    /// signals that no entry is currently running
    static let noEntry = RunningEntry(
        id: Int64(NSNotFound),
        start: Date.distantFuture,
        project: ProjectPresets.shared.NoProject,
        entryDescription: "Not Running",
        tags: [],
        billable: false
    )
    
    static let placeholder = RunningEntry(
        id: Int64(NSNotFound),
        start: Date(),
        project: ProjectPresets.shared.NoProject,
        entryDescription: "Placeholder",
        tags: ["Tag"],
        billable: false
    )
}

extension RunningEntry {
    /// expressly for seeing if the running entry has had substantial updates to be displayed on the widget
    /// note that the `UserDefaults` copy will have stripped down information
    static func widgetMatch(_ lhs: RunningEntry?, _ rhs: RunningEntry?) -> Bool {
        guard !(lhs == .none && rhs == .none) else { return true }
        guard
            let lhs = lhs,
            let rhs = rhs
        else { return false }
        return lhs.start == rhs.start
            && lhs.id == rhs.id
            && lhs.entryDescription == rhs.entryDescription
            && lhs.pid == rhs.pid
            && lhs.tags == rhs.tags
    }
}
