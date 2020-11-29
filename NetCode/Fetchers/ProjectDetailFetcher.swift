//
//  ProjectDetailFetcher.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/// wrapper because of the data formatting
struct RawProjectResponse: Decodable {
    let data: RawProject?
}

func FetchProjectDetails(
    pid: Int,
    token: String
) -> AnyPublisher<StaticProject, Error> {
    /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/projects.md#get-project-data
    let request = formRequest(
        url: URL(string: "\(API_URL)/projects/\(pid)")!,
        auth: auth(token: token)
    )
    
    return URLSession.shared.dataTaskPublisher(for: request)
        .map(dataTaskMonitor)
        .tryMap { data -> StaticProject in
            guard let rawProject = try JSONDecoder(dateStrategy: .iso8601).decode(RawProjectResponse.self, from: data).data else {
                throw NetworkError.emptyReply
            }
            return StaticProject(name: rawProject.name, color: Color(hex: rawProject.hex_color), id: rawProject.id)
        }
        .eraseToAnyPublisher()
}
