//
//  EntryModel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// models a `TimeEntryLike` object as it is being edited
final class EntryModel: ObservableObject {
    
    // MARK:- TimeEntry Properties
    let id: Int64
    @Published var start: Date
    @Published var end: Date
    @Published var project: Project
    //TODO: include tags here
    @Published var entryDescription: String
    @Published var billable: Bool
    
    /// tracks what is being edited in a second modal
    @Published var field: Field? = .none
    
    var duration: TimeInterval {
        end - start
    }
    
    /// what field is seleted that requires a second layer modal to pop up
    enum Field {
        case start
        case end
        case project
        case entryDescription
        /// no `billable`, that can be a simple toggle
    }
    
    init(from entry: TimeEntryLike) {
        id = entry.id
        start = entry.start
        end = entry.end
        project = entry.project
        entryDescription = entry.entryDescription
        billable = entry.billable
    }
    
    private init(from model: EntryModel) {
        id = model.id
        start = model.start
        end = model.end
        project = model.project
        entryDescription = model.entryDescription
        billable = model.billable
    }
}


extension EntryModel {
    func update(with new: EntryModel) -> Void {
        /// ignored: `id`, `field`
        start = new.start
        end = new.end
        project = new.project
        entryDescription = new.entryDescription
        billable = new.billable
    }
}

extension EntryModel: Equatable {
    static func == (lhs: EntryModel, rhs: EntryModel) -> Bool {
        /// ignored: `field`
        lhs.id == rhs.id
            && lhs.billable == rhs.billable
            && lhs.start == rhs.start
            && lhs.end == rhs.end
            && lhs.entryDescription == rhs.entryDescription
            && lhs.project == rhs.project
    }
}

extension EntryModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        EntryModel(from: self)
    }
}

extension EntryModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(start)
        hasher.combine(end)
        hasher.combine(billable)
        hasher.combine(entryDescription)
        hasher.combine(project)
    }
}
