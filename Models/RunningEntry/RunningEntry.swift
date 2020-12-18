//
//  RunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

final class RunningEntry: NSObject, NSSecureCoding {
    
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
        project: ProjectLike,
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

    //MARK:- NSSecureCoding Compliance

    static var supportsSecureCoding = true
    
    /**
     NOTE: this init only finds `pid`, it does not use that to get the associated `project`
     This is so that we do not need to make `projectLike` `NSSecureCoding` compliant.
     Whatever decodes this will need to do its own work to find the `project`.
     */
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(pid, forKey: "pid")
        coder.encode(start, forKey: "start")
        coder.encode(entryDescription, forKey: "entryDescription")
        coder.encode(tags, forKey: "tags")
    }
    
    /** Note to future self
     - I would like to break this whole thing into an extension in a separate file, however
     - Swift will not allow a designated (i.e. non-`convenience`) `init` to exist within an extension
     
     */
    init?(coder: NSCoder) {
        id = Int64(coder.decodeInteger(forKey: "id"))
        pid = Int64(coder.decodeInteger(forKey: "pid"))
        
        /// note: we will assign project later, for now leave `unknown`
        project = ProjectLike.special(.UnknownProject)
        
        tags = coder.decodeObject(forKey: "tags") as? [String]
            ?? []
        billable = coder.decodeBool(forKey: "billable")
        
        guard
            let start = coder.decodeObject(forKey: "start") as? Date,
            let entryDescription = coder.decodeObject(forKey: "entryDescription") as? String
        else { return nil }
        self.start = start
        self.entryDescription = entryDescription
        
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
