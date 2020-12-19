//
//  BeginningOfWeek.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func putWeekday(_ weekday: Int, token: String) -> Void {
    /// formulate PUT request
    var request = formRequest(
        url: NetworkConstants.userDataURL,
        auth: auth(token: token)
    )
    request.httpMethod = "PUT"
    
    URLSession.shared.uploadTask(
        with: request,
        /** https://github.com/toggl/toggl_api_docs/blob/master/chapters/users.md
         Refer to documentation, Toggl runs 0-6 (Sunday = 0),
         whereas Apple runs 1-7 (Sunday = 1).
         Hence we adjust by 1 when converting
         */
        from: try! JSONSerialization.data(withJSONObject: ["user":["beginning_of_week":weekday - 1]])
    ){ (responseData, response, error) in
        if let error = error {
            #if DEBUG
            print("Error making PUT request: \(error.localizedDescription)")
            #endif
            return
        }
        
        if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
            guard responseCode == 200 else {
                #if DEBUG
                print("Invalid response code: \(responseCode) with data \(responseData)")
                #endif
                return
            }
        }
    }
    .resume()
}
