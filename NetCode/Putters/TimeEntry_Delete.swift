//
//  TimeEntry_Delete.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeEntry {
    func delete(with token: String) {
        /// Docs @ https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#update-a-time-entry
        var request = formRequest(
            url: NetworkConstants.url(for: self),
            auth: auth(token: token)
        )
        request.httpMethod = "DELETE"
        
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
                print("Successfully deleted TimeEntry")
                #endif
            }
            
        }
            .resume()
    }
}
