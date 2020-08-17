//
//  Data.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class TimeData: ObservableObject {
    
    init(projects: [Project]){
        self.projects = projects
    }
    
    var entriesPipe: AnyCancellable? = nil
    func newLoadEntries(start: Date, end: Date, user: User, context: NSManagedObjectContext) -> Void {
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
        let loader = RecursiveLoader()
        entriesPipe = loader.loadPages(
            context: context,
            projects: self.projects,
            api_string: api_string,
            auth: auth(token: user.token)
        )
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .finished:
                    break
                }
            },
            receiveValue: {
                self.entries = $0
            }
        )
    }
    
    
    /// the `Project`s the user is filtering for
    @Published var terms = SearchTerms()
    
    
    // MARK:- Projects
    /// List of the user's `Project`s
    @Published var projects: [Project]
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
            .map { $0.data }
            .decode(
                type: [Project]?.self,
                /// pass `managedObjectContext` to decoder so that a CoreData object can be created
                decoder: JSONDecoder(context: context)
            )
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                /// if there was an error and nothing came through, do not edit the data
                /// NOTE: if we correctly received 0 `Project`s (for some reason), this should correctly wipe the `Project`s in CoreData
                guard let projects = $0 else { return }
                self.projects = projects
                /// save newly created CoreData objects
                try! context.save()
            })
    }
}
