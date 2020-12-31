//
//  TimeEntryRepresentative+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData


extension TimeEntryRepresentative {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeEntryRepresentative> {
        return NSFetchRequest<TimeEntryRepresentative>(entityName: "TimeEntryRepresentative")
    }

    @NSManaged public var name: String?
    @NSManaged public var project: Project?
    @NSManaged public var represents: NSSet?
    @NSManaged public var representsCount: Int16 /// NOTE: is optional, but cannot be marked optional here.
    
    /// cast toMany relationship to `Set`
    public var _represents: Set<TimeEntry> {
        Set(represents as? Set<TimeEntry> ?? [])
    }
}

// MARK: Generated accessors for represents
extension TimeEntryRepresentative {

    @objc(addRepresentsObject:)
    @NSManaged public func addToRepresents(_ value: TimeEntry)

    @objc(removeRepresentsObject:)
    @NSManaged public func removeFromRepresents(_ value: TimeEntry)

    @objc(addRepresents:)
    @NSManaged public func addToRepresents(_ values: NSSet)

    @objc(removeRepresents:)
    @NSManaged public func removeFromRepresents(_ values: NSSet)

}

extension TimeEntryRepresentative : Identifiable {

}
