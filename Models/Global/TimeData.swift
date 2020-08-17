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
    
    /// A delegate between SwiftUI and CoreData, storing all of the user's `TimeEntry`s
    /// `EnvironmentObject` was chosen to prevent the UI hitting CoreData on every refresh
    @Published var entries = [TimeEntry]()
    var entriesPipe: AnyCancellable? = nil
    
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
