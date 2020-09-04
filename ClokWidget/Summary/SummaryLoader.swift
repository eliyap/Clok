//
//  SummaryLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

func fetchSummary(
    token: String,
    wid: Int,
    completion:@escaping (Summary?, Error?) -> Void
) -> Void {
    /// API URL documentation:
    /// https://github.com/toggl/toggl_api_docs/blob/master/reports/summary.md
    let url = [
        "\(REPORT_URL)/summary?user_agent=\(user_agent)",
        "workspace_id=\(wid)",
        "since=\(Date().midnight.iso8601)",
        "end=\(Date().midnight.advanced(by: .day).iso8601)"
    ].joined(separator: "&")
    
    let request = formRequest(
        url: URL(string: url)!,
        auth: auth(token: token)
    )
    
    URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
        guard error == nil else {
            completion(nil, error!)
            return
        }
        guard let data = data else {
            completion(nil, NetworkError.other)
            return
        }
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard 200...299 ~= code else {
            completion(nil, NetworkError.statusCode(code: code))
            return
        }
        do {
            let summary = try JSONDecoder(dateStrategy: .iso8601).decode(Summary.self, from: data)
            completion(summary, nil)
        } catch {
            completion(nil, NetworkError.serialization)
        }
    }.resume()
}
