//
//  ConditionalFetch.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

/**
 get whatever projects are available. try to load from disk first,
 but if nothing is on disk, fetch from online
 */
func loadOrFetchProjects(user: User, context: NSManagedObjectContext) -> [Project] {
    /// try to load from disk
    if
        let loaded = loadProjects(context: context),
        loaded.count > 0
    {
        return loaded
    }
    /// nothing loaded locally, fetch from online
    else if
        let fetched = fetchProjects(token: user.token, wid: user.chosen.wid, in: context),
        fetched.count > 0
    {
        return fetched
    }
    /// couldn't find any projects anywhere!
    return []
}

/**
 get whatever projects are available. try to load from disk first,
 but if nothing is on disk, fetch from online
 */
func loadOrFetchEntries(
    from start: Date,
    to end: Date,
    user: User,
    context: NSManagedObjectContext
) -> [TimeEntry] {
    // request user data
    
    
    /// try to load from disk
    if
        let loaded = loadEntries(from: start, to: end, context: context),
        loaded.count > 0
    {
        return loaded
    }
    /// nothing loaded locally, fetch from online
    else if
        let fetched = fetchEntries(token: user.token, wid: user.chosen.wid, from: start, to: end, in: context),
        fetched.count > 0
    {
        return fetched
    }
    /// couldn't find any projects anywhere!
    return []
}

