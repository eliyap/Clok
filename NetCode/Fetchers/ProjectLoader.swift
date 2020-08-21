//
//  ProjectLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class ProjectLoader: ObservableObject {
    private var loader: AnyCancellable? = nil
    
    /**
     Use Combine to make an async network request for all the User's `Project`s
     */
    func fetchProjects(
        user: User,
        context: NSManagedObjectContext,
        completion: (([Project]) -> Void)? = nil
    ) -> Void {
        loader = ProjectLoader.projectPublisher(user: user)
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
                
                /// execute completion block, if any
                if
                    let completion = completion,
                    let projects = loadProjects(context: context)
                {
                    completion(projects)
                }
            }
    }
    
    static func projectPublisher(user: User) -> AnyPublisher<[RawProject], Never> {
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
        let request = formRequest(
            url: URL(string: "\(API_URL)/workspaces/\(user.chosen.wid)/projects?user_agent=\(user_agent)")!,
            auth: auth(token: user.token)
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(dataTaskMonitor)
            .decode(
                type: [RawProject].self,
                /// pass `managedObjectContext` to decoder so that a CoreData object can be created
                decoder: JSONDecoder(dateStrategy: .iso8601)
            )
            /// discard array on error
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
