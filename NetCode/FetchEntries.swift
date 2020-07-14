//
//  FetchData.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

func fetchEntries(
    user: User,
    from start: Date,
    to end: Date,
    context: NSManagedObjectContext,
    projects: [Project]
) -> [TimeEntry]? {
    print("NOW FETCHING ENTRIES")
    // assemble request URL (page is added later)
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
    
    // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
    let api_string = "\(REPORT_URL)details?" + [
        "user_agent=\(user_agent)",    // identifies my app
        "workspace_id=\(user.chosen.wid)", // provided by the User
        "since=\(df.string(from: start))",
        "until=\(df.string(from: end))"
    ].joined(separator: "&")
    
    let result = fetchDetailedReport(
        api_string: api_string,
        token: user.token,
        context: context,
        projects: projects
    )
    var entries: [TimeEntry]? = nil
    DispatchQueue.global(qos: .background).async {
        switch result {
        case let .success(fetched):
            mergeEntries(context: context, entries: fetched, projects: projects)
            
        case .failure(.request):
            // temporary micro-copy
            print("We weren't able to fetch your data. Maybe the internet is down?")
        case let .failure(error):
            print(error)
        }
    }
    
    return entries
}

func mergeEntries(
    context: NSManagedObjectContext,
    entries: [RawTimeEntry],
    projects: [Project]
) -> Void {
    if let savedEntries = loadEntries(from: Date.distantPast, to: Date.distantFuture, context: context){
        entries.forEach{ entry in
            if let oldEntry = savedEntries.first(where: {$0.id == entry.id}) {
                oldEntry.update(from: entry, context: context)
            } else {
                try! context.insert(TimeEntry(from: entry, context: context, projects: projects))
            }
        }
    }
    /// save projects
    try! context.save()
}
