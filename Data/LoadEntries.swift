//
//  LoadEntries.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

/// fetch entries from Core Data storage
func loadEntries(
    from start: Date,
    to end: Date,
    context: NSManagedObjectContext
) -> [TimeEntry]? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
    fetchRequest.predicate = NSPredicate(
        format: "(end >= %@) AND (start <= %@)",
        NSDate(start),
        NSDate(end)
    )
    do {
        let entries = try context.fetch(fetchRequest) as! [TimeEntry]
        return entries
    } catch {
        print(error)
    }
    return nil
}
