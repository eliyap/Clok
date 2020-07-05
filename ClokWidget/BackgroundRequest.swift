//
//  BackgrounRequest.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func loadUserData(completion:@escaping (User?, Error?) -> Void) {
    
    /// load user API token from keychain
    guard let user = getCredentials() else {
        completion(nil, KeychainError.noData)
        return
    }
    let request = formRequest(
        url: runningURL,
        auth: auth(token: user.token)
    )
    URLSession.shared.dataTask(with: request) {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        guard error == nil else {
            completion(nil, error)
            return
        }
        guard
            let http_response = resp as? HTTPURLResponse,
            let data = data
        else {
            completion(nil, error)
            return
        }
        guard http_response.statusCode == 200 else {
            completion(nil, NetworkError.statusCode(code: http_response.statusCode))
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            completion(User(json as! [String: AnyObject])!, error)
        } catch {
            completion(nil, NetworkError.serialization)
        }
    }.resume()
}
