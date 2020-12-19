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
        
        #if DEBUG
        #warning("debug")
        print("\(NetworkConstants.API_URL)/time_entries/\(id)\(NetworkConstants.agentSuffix)")
        print(String(data: try! JSONEncoder().encode(self), encoding: .utf8))
        #endif
        
        URLSession.shared.uploadTask(
            with: request,
            from: try! JSONEncoder().encode(["time_entry":self]),
            completionHandler: NetworkConstants.putHandler
        )
            .resume()
    }
}
