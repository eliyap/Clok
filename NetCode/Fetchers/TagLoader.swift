//
//  TagLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class TagLoader: ObservableObject {
    var loader: AnyCancellable? = nil
    
    static func fetchTags(
        user: User,
        context: NSManagedObjectContext
    ) -> AnyPublisher<[Tag], Never> {
        TagLoader.tagPublisher(user: user)
            /// switch to main thread for CoreData changes
            .receive(on: DispatchQueue.main)
            .map {
                TagLoader.saveTags(rawTags: $0, context: context)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Save provided `RawTag`s into CoreData, and return the updated list of `Tag`s
     */
    static func saveTags(
        rawTags: [RawTag],
        context: NSManagedObjectContext
    ) -> [Tag] {
        rawTags.forEach {
            context.insert(Tag(from: $0, context: context))
            /// debug
            print("tag name: \($0.name)")
        }
        /// save CoreData changes
        try! context.save()
        
        /// return fresh list from Core Data
        return loadTags(context: context) ?? []
    }
    
    static func tagPublisher(user: User) -> AnyPublisher<[RawTag], Never> {
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
        let request = formRequest(
            url: URL(string: "\(API_URL)/workspaces/\(user.chosen.wid)/tags\(agentSuffix)")!,
            auth: auth(token: user.token)
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(dataTaskMonitor)
            .decode(
                type: [RawTag].self,
                decoder: JSONDecoder(dateStrategy: .iso8601)
            )
            /// discard array on error
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
