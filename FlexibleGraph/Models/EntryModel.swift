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
    // id is not editable and is not included
    @Published var start: Date
    @Published var end: Date
    var duration: TimeInterval {
        start - end
    }
    //TODO: include project here
    //TODO: include tags here
    @Published var entryDescription: String
    @Published var billable: Bool
    
    init(from entry: TimeEntryLike) {
        start = entry.start
        end = entry.end
        entryDescription = entry.entryDescription
        billable = entry.billable
    }
}
