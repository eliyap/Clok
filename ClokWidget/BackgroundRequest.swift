//
//  BackgrounRequest.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func loadUserData(completion:@escaping (User?, Error?) -> Void) {
    // save a faux API to the temporary directory and fetch it
    // in your app you'll fetch it from a real API
    let request = formRequest(
        url: userDataURL,
        auth: auth(token: "3302cfeeaf4aa0920422ee8f0a139fd7")
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
            completion(User(json as! Dictionary<String, AnyObject>)!, error)
        } catch {
            completion(nil, NetworkError.serialization)
        }
    }.resume()
}
