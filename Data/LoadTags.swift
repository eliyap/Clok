//
//  LoadTags.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

/// fetch projects from Core Data storage
func loadTags(context: NSManagedObjectContext) -> [Tag]? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Tag.entityName)
    do {
        let projects = try context.fetch(fetchRequest) as! [Tag]
        return projects
    } catch {
        print(error)
    }
    return nil
}
