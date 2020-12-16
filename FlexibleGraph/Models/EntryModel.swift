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
    
    let id: Int64
    
    @Published var start: Date
    @Published var end: Date
    var duration: TimeInterval {
        end - start
    }
    @Published var project: Project
    //TODO: include tags here
    @Published var entryDescription: String
    @Published var billable: Bool
    
    @Published var field: Field? = .none
    
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
        project = entry.wrappedProject
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
