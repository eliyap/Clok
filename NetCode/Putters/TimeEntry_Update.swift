//
//  TimeEntry_Update.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

extension TimeEntry {
    
    /// Creates an `uploadTask` to send changes to Toggl
    /// - Parameter token: authentication token
    func upload(with token: String) {
        /// Docs @ https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#update-a-time-entry
        var request = formRequest(
            url: URL(string: "\(NetworkConstants.API_URL)/time_entries/\(id)\(NetworkConstants.agentSuffix)")!,
            auth: auth(token: token)
        )
        request.httpMethod = "PUT"
        
        URLSession.shared.uploadTask(
            with: request,
            from: try! JSONEncoder().encode(["time_entry":self])
        ){ (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
            }
        }
            .resume()
    }
}
