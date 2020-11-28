//
//  MR_Intent_Default.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension MultiRingConfigurationIntent {
    /// Define a default configuration
    static let Default: MultiRingConfigurationIntent = {
        let def = MultiRingConfigurationIntent()
        def.Period = .day
        def.PriorDay = .whole
        def.Theme = .system
        return def
    }()
}
