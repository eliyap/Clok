//
//  SummaryEquatable.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension Summary: Equatable {
    static func ==(lhs: Summary, rhs: Summary) -> Bool {
        /**
         a fairly weak comparison
         */
        return lhs.total == rhs.total
            && lhs.projects.count == rhs.projects.count
    }
}
