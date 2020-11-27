//
//  DetailedLoader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func fetchDetailed(
    token: String,
    wid: Int,
    completion:@escaping (Detailed?, Error?) -> Void
) -> Void {
    /// API URL documentation:
    /// https://github.com/toggl/toggl_api_docs/blob/master/reports/detailed.md
    let url = [
        "\(REPORT_URL)/details?user_agent=\(user_agent)",
        "workspace_id=\(wid)",
        /// cast 1 day into the past for roll-over entries
        "since=\(Date().midnight.advanced(by: -.day).iso8601)",
        "until=\(Date().midnight.advanced(by: .day).iso8601)",
        /// **warning** ("only loads 1 page!")
        "page=0",
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
            #warning("DEBUG")
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
            print(json)
            let detailed = try JSONDecoder(dateStrategy: .iso8601).decode(Detailed.self, from: data)
            completion(detailed, nil)
        } catch {
            completion(nil, NetworkError.serialization)
        }
    }.resume()
}
