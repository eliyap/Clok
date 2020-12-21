//
//  TimeEntry_Update.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

fileprivate struct UpdatedEntry: Decodable {
    let data: Details
    
    struct Details: Decodable {
        /// timestamp of successful update
        let at: Date
        
        /// note, name differs from `RawTimeEntry`
        let billable: Bool
        
        /// NOTE: if `description` == "", the field will be absent.
        let description: String?
        let start: Date
        let stop: Date
        let duration: Double
        let tags: [String]
        let id: Int64
        let pid: Int?
        let uid: Int; // user ID
        
        /// present in the blob, but unused by `Clok`
        //    duronly = 0;
        //    guid = <some long hex thing>;
        //    wid
    }
}

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
                #if DEBUG
                print(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))
                print(try? JSONDecoder(dateStrategy: .iso8601).decode(UpdatedEntry.self, from: data))
                #endif
            }
            
        }
            .resume()
    }
}
