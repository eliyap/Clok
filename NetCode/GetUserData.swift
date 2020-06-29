//
//  GetUserData.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func getUserData(with request: URLRequest) -> Result<User, NetworkError> {
    var result: Result<User, NetworkError>!
    var user: User!
    
    // semaphore for API call
    let sem = DispatchSemaphore(value: 0)
    
    //define completionHandler
    let handler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        defer{ sem.signal() }
        
        print("canary2")
        guard error == nil else {
            result = .failure(.request(error: error! as NSError))
            return
        }
        guard
            let http_response = resp as? HTTPURLResponse,
            let data = data
        else {
            return
        }
        guard http_response.statusCode == 200 else {
            result = .failure(.statusCode(code: http_response.statusCode))
            return
        }
        print("canary3")
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            user = User(json as! Dictionary<String, AnyObject>)!
        } catch {
            result = .failure(.serialization)
        }
    }
    print("canary1")
    
    URLSession.shared.dataTask(
        with: request,
        completionHandler: handler
    ).resume()
    
    /// wait here until call returns, or timeout if it took too long
    if sem.wait(timeout: .now() + 15) == .timedOut { return .failure(.timeout) }
    
    print("canaryX")
    // only return success if there is no failure
    switch result {
    case .failure(_):
        return result
    default:
        return .success(user)
    }
}
