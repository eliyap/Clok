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
    
    /// transient computed variable that counts up the number of `TimeEntry`s this is representing
    @objc var count: Int16 {
        Int16(represents?.count ?? .zero)
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
