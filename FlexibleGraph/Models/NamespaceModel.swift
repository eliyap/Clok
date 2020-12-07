//
//  NamespaceModel.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// Helps `matchedGeometryEffect` to identify `TimeEntry` views as unique across multiple days
struct NamespaceModel: Hashable {
    /// `TimeEntryLike` ID
    let entryID: Int64
    
    /// array index of the day in which the `TimeEntry` is contained
    let dayIndex: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(entryID)
        hasher.combine(dayIndex)
    }
}

extension NamespaceModel {
    static let none = NamespaceModel(entryID: StaticEntry.noEntry.id, dayIndex: .zero)
}
