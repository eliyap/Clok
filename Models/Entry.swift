//
//  Entry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// a data type with the general shape of a `TimeEntry`
protocol TimeEntryLike {
    var start: Date { get }
    var end: Date { get }
    var project: ProjectLike { get }
}
