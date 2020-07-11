//
//  CDTimeEntry+CoreDataProperties.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData


extension CDTimeEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTimeEntry> {
        return NSFetchRequest<CDTimeEntry>(entityName: "CDTimeEntry")
    }

    @NSManaged public var name: String?
    @NSManaged public var tid: Int64
    @NSManaged public var task: String?
    @NSManaged public var dur: Double
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var project: CDProject?

    public var wrappedDescription: String {
        name ?? "No Description"
    }
    
    
    
}
