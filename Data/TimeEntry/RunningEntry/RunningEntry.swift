//
//  RunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct RunningEntry: Codable {
    
    var id: Int64
    var pid: Int
    var start: Date
    var project: ProjectLite
    var entryDescription: String
    var tags: [String] = []
    var billable: Bool
    
    let df = DateFormatter()
    
    init(
        id: Int64,
        start: Date,
        project: ProjectLite,
        entryDescription: String,
        tags: [String]?,
        billable: Bool
    ){
        self.id = id
        self.start = start
        self.project = project
        self.pid = Int(project.id)
        self.entryDescription = entryDescription
        self.tags = tags ?? []
        self.billable = billable
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case pid = "pid"
        case start = "start"
        case project = "project"
        case entryDescription = "entryDescription"
        case tags = "tags"
        case billable = "billable"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(pid, forKey: .pid)
        try container.encode(start, forKey: .start)
        try container.encode(project, forKey: .project)
        try container.encode(entryDescription, forKey: .entryDescription)
        try container.encode(tags, forKey: .tags)
        try container.encode(billable, forKey: .billable)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int64.self, forKey: .id)
        pid = try container.decode(Int.self, forKey: .pid)
        start = try container.decode(Date.self, forKey: .start)
        project = try container.decode(ProjectLite.self, forKey: .project)
        entryDescription = try container.decode(String.self, forKey: .entryDescription)
        tags = try container.decode([String].self, forKey: .tags)
        billable = try container.decode(Bool.self, forKey: .billable)
    }
}

extension RunningEntry {
    /// signals that no entry is currently running
    static let noEntry = RunningEntry(
        id: Int64(NSNotFound),
        start: Date.distantFuture,
        project: .NoProjectLite,
        entryDescription: "Not Running",
        tags: [],
        billable: false
    )
    
    static let placeholder = RunningEntry(
        id: Int64(NSNotFound),
        start: Date(),
        project: .NoProjectLite,
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

extension RunningEntry: TimeEntryLike {
    /// `TimeEntryLike` compliance
    var end: Date { Date() } /// always return current time
    var duration: TimeInterval { Date() - start } /// always return latest duration
    var color: Color { project.color }
    var tagStrings: [String] { tags }
    var wrappedProject: ProjectLike { .lite(project) }
    var identifier: Int64 { id }
}

extension RunningEntry: Equatable {
    
}
