//
//  EntryLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 17/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class EntryLoader: ObservableObject {
    var entryLoader: AnyCancellable? = nil
    
    func fetchEntries(
        range: DateRange,
        user: User,
        projects: [Project],
        context: NSManagedObjectContext
    ) -> Void {
        // assemble request URL (page is added later)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
        
        // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
        let api_string = "\(REPORT_URL)details?" + [
            "user_agent=\(user_agent)",    // identifies my app
            "workspace_id=\(user.chosen.wid)", // provided by the User
            "since=\(df.string(from: range.start))",
            "until=\(df.string(from: range.end))"
        ].joined(separator: "&")
    
        entryLoader = recursiveLoadPages(
            projects: projects,
            api_string: api_string,
            auth: auth(token: user.token)
        )
            /// switch to main thread before performing CoreData work
            .receive(on: DispatchQueue.main)
            .catch({ error -> AnyPublisher<[RawTimeEntry], Never> in
                print(error)
            
                return Just([RawTimeEntry]())
                    .eraseToAnyPublisher()
            })
            .sink(receiveValue: { rawEntries in
                rawEntries.forEach { (rawEntry: RawTimeEntry) in
                    context.insert(TimeEntry(from: rawEntry, context: context, projects: projects))
                }
                try! context.save()
            })
    }
    
    var projectsPipe: AnyCancellable? = nil
    
    /**
     Use Combine to make an async network request for all the User's `Project`s
     */
    func fetchProjects(user: User?, context: NSManagedObjectContext) -> Void {
        /// abort if user is not logged in
        guard let user = user else { return }
        
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
        let request = formRequest(
            url: URL(string: "\(API_URL)/workspaces/\(user.chosen.wid)/projects?user_agent=\(user_agent)")!,
            auth: auth(token: user.token)
        )
        
        projectsPipe = URLSession.shared.dataTaskPublisher(for: request)
            .map(dataTaskMonitor)
            .decode(
                type: [RawProject].self,
                /// pass `managedObjectContext` to decoder so that a CoreData object can be created
                decoder: JSONDecoder(dateStrategy: .iso8601)
            )
            /// discard array on error
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { (rawProjects: [RawProject]) in
                let projects = loadProjects(context: context) ?? []
                rawProjects.forEach { rawProject in
                    if let match = projects.first(where: {$0.id == rawProject.id}) {
                        /// if `rawProject` is more recent, update `Project` on disk
                        if match.fetched < rawProject.at {
                            match.update(from: rawProject)
                        }
                    } else {
                        /// if no match was found, insert new `Project`
                        context.insert(Project(raw: rawProject, context: context))
                    }
                }
                /// save CoreData changes
                try! context.save()
            }
    }
}
