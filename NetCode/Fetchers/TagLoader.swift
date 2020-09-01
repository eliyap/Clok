//
//  TagLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

final class TagLoader: ObservableObject {
    private var loader: AnyCancellable? = nil
    
    func fetchTags(user: User) -> Void {
        loader = URLSession.shared.dataTaskPublisher(for: formRequest(
            /// https://github.com/toggl/toggl_api_docs/blob/b19c3b61f2b1be2eeccc28ea4e6acee38cfc72a1/chapters/tags.md#tags
            url: URL(string: "\(API_URL)/tags\(agentSuffix)")!,
            auth: auth(token: user.token)
        ))
            .map(dataTaskMonitor)
            .sink (
                receiveCompletion: {_ in},
                receiveValue:{ data in
                    print(try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]])
                }
            )
    }
}
