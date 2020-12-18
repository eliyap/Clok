//
//  TimeEntryLike.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/// a data type with the general shape of a `TimeEntry`
protocol TimeEntryLike {
    var id: Int64 { get }
    var start: Date { get }
    var end: Date { get }
    var color: Color { get }
    var entryDescription: String { get } /// note: `description` is a reserved word in iOS
    var project: ProjectLike { get }
    var tagStrings: [String] { get }
    var duration: TimeInterval { get }
    var billable: Bool { get }
}
