//
//  TimeEntryRepresentative+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TimeEntryRepresentative)
public class TimeEntryRepresentative: NSManagedObject {

    static let entityName = "TimeEntryRepresentative"
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(
        in context: NSManagedObjectContext,
        name: String?,
        project: Project?
    ) {
        super.init(entity: Self.entity(), insertInto: context)
        self.name = name
        self.project = project
    }
    
}

