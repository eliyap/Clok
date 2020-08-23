//
//  Tag+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String
    @NSManaged public var id: Int64
    @NSManaged public var wid: Int64
    @NSManaged public var entries: NSSet?
    
    public var entryArray: [TimeEntry] {
        return Array(entries as? Set<TimeEntry> ?? [])
    }
}

// MARK: Generated accessors for entries
extension Tag {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: TimeEntry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: TimeEntry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension Tag : Identifiable {

}
