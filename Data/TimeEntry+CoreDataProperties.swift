//
//  TimeEntry+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData

extension TimeEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeEntry> {
        return NSFetchRequest<TimeEntry>(entityName: "TimeEntry")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var dur: Double
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var project: Project?

    public var wrappedDescription: String {
        name ?? "No Description"
    }
    
    public var wrappedID: Int {
        Int(id)
    }
    
    public var wrappedStart: Date {
        start ?? Date.distantPast
    }
    
    public var wrappedEnd: Date {
        end ?? Date.distantFuture
    }
    
    // default project to no project here in future
}
