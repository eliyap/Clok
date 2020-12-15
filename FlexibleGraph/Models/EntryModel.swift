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
}
