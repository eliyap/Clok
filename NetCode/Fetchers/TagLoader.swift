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
    private var loader: AnyCancellable? = nil
    
    func fetchTags(
        user: User,
        context: NSManagedObjectContext
    ) -> Void {
        /// Documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/b19c3b61f2b1be2eeccc28ea4e6acee38cfc72a1/chapters/workspaces.md#get-workspace-tags
        loader = TagLoader.tagPublisher(user: user)
            .receive(on: DispatchQueue.main)
            .sink { (rawTags: [RawTag]) in
                rawTags.forEach {
                    context.insert(Tag(from: $0, context: context))
                }
                /// save CoreData changes
                try! context.save()
            }
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
