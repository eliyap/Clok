//
//  CDProject+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData


extension CDProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProject> {
        return NSFetchRequest<CDProject>(entityName: "CDProject")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var color: NSObject?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension CDProject {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: CDTimeEntry)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: CDTimeEntry)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
