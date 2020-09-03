//
//  SummaryLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

func summaryPublisher(token: String, wid: Int) -> AnyPublisher<Summary?, Never> {
    /// API URL documentation:
    /// https://github.com/toggl/toggl_api_docs/blob/master/reports/summary.md
    let url = [
        "\(API_URL)/summary/projects?user_agent=\(user_agent)",
        "workspace_id=\(wid)",
        "since=\(Date().midnight.iso8601)",
        "end=\(Date().midnight.advanced(by: .day).iso8601)"
    ].joined(separator: "&")
    
    let request = formRequest(
        url: URL(string: url)!,
        auth: auth(token: token)
    )
    
    return URLSession.shared.dataTaskPublisher(for: request)
        .map(dataTaskMonitor)
        .decode(type: Summary.self, decoder: JSONDecoder(dateStrategy: .iso8601))
        .map(toOptional)
        .replaceError(with: nil)
        .eraseToAnyPublisher()
}
