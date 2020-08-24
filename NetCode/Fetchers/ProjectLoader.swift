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
    var loader: AnyCancellable? = nil
    
    /**
     Use Combine to make an async network request for all the User's `Project`s
     */
    static func fetchProjects(
        user: User,
        context: NSManagedObjectContext
    ) -> AnyPublisher<[Project], Never> {
        ProjectLoader.projectPublisher(user: user)
            /// switch to main thread for CoreData changes
            .receive(on: DispatchQueue.main)
            .map {
                ProjectLoader.saveProjects(rawProjects: $0, context: context)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Save provided `RawProject`s into CoreData, and return the updated list of `Project`s
     */
    static func saveProjects(
        rawProjects: [RawProject],
        context: NSManagedObjectContext
    ) -> [Project] {
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
        #if DEBUG
        print("Updating local projects")
        #endif
        /// save CoreData changes
        try! context.save()
        
        /// return fresh list from Core Data
        return loadProjects(context: context) ?? []
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
                decoder: JSONDecoder(dateStrategy: .iso8601)
            )
            /// discard array on error
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
