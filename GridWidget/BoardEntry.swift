//
//  BoardEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import WidgetKit

struct BoardEntry: TimelineEntry {
    public let date: Date
    public let board: Board?
}
