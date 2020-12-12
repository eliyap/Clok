//
//  ProjectPresets.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

/// a collection of preset temporary `Project`s that can be created at will in any `NSManagedObjectContext`
struct ProjectPresets {
    
    /// define a shared struct with a "floating" `NSManagedObjectContext`
    static let shared = ProjectPresets(moc: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    
    let NoProject: Project
    let AnyProject: Project
    let UnknownProject: Project
    
    init(moc: NSManagedObjectContext) {
        NoProject = Project(raw: .NoProject, context: moc)
        AnyProject = Project(raw: .AnyProject, context: moc)
        UnknownProject = Project(raw: .UnknownProject, context: moc)
    }
}

