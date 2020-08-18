//
//  Project+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String
    @NSManaged public var id: Int64
    @NSManaged public var color: String
    @NSManaged public var entries: NSSet?
    
    public var wrappedName: String {
        name ?? "No Name"
    }
    
    public var wrappedID: Int {
        Int(id)
    }
    
    public var wrappedColor: Color {
        Color(hex: color ?? StaticProject.unknown.wrappedColor.toHex)
    }
    
    public var entryArray: [TimeEntry] {
        let set = entries as? Set<TimeEntry> ?? []
        return set.sorted {
            $0.start < $1.start
        }
    }
}

// MARK: Generated accessors for tasks
extension Project {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TimeEntry)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TimeEntry)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
