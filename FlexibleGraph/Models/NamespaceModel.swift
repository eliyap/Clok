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
    let entry: TimeEntry?
    
    /// array index of the week (row) in which the `TimeEntry` is contained
    let row: Int
    
    /// array index of the day (column) in that week (row) in which the `TimeEntry` is contained
    let col: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(entry?.id ?? .zero) /// only hash the ID
        hasher.combine(row)
        hasher.combine(col)
    }
}

extension NamespaceModel {
    /// placeholder representing no selection
    static let none = NamespaceModel(entry: .none, row: .zero, col: .zero)
}
