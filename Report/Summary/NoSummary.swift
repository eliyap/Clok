//
//  NoSummary.swift
//  ClokWidgetExtension
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension Summary {
    fileprivate init(total: TimeInterval, projects: [Summary.Project]){
        self.total = total
        self.projects = projects
    }
    static let noSummary = Summary(total: 0, projects: [])
}
