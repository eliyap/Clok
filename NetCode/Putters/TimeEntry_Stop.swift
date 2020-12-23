//
//  TimeEntry_Stop.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeEntry {
    
    /// Unsafe Method to make it just stop.
    static func justStop() -> Void {
        let token = try! getKey().token
        let running = WidgetManager.running
        guard running != .noEntry else { return }
        TimeEntry.stop(id: running.id, with: token) { _ in }
    }
    
    static func stop(
        id: Int64,
        with token: String,
        completion: @escaping (TimeEntry) -> Void
    ) {
        /// Docs @ https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#update-a-time-entry
        var request = formRequest(
            url: URL(string: "\(NetworkConstants.API_URL)/time_entries/\(id)/stop\(NetworkConstants.agentSuffix)")!,
            auth: auth(token: token)
        )
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                #if DEBUG
                print("Error making PUT request: \(error.localizedDescription)")
                #endif
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let data = data {
                guard responseCode == 200 else {
                    #if DEBUG
                    print("Invalid response code: \(responseCode) with data: \(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))")
                    #endif
                    return
                }
                #if DEBUG
                print("Successfully stopped TimeEntry")
                #endif
                #warning("missing completion")
    //            completion(self)
            }
        }
            .resume()
    }
}
