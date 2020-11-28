//
//  MultiRingEntry.swift
//  MultiRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import Intents
import SwiftUI

struct MultiRingEntry: TimelineEntry {
    let date: Date
    let projects: [Detailed.Project]
    let running: RunningEntry
    let config: MultiRingConfigurationIntent
}
