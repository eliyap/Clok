//
//  FormRequest.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func formRequest(url: URL, auth: String) -> URLRequest {
    var request = URLRequest(url: url)
    
    // set headers
    request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return request
}

func auth(token: String) -> String {
    Data("\(token):api_token".utf8).base64EncodedString()
}

func auth(email: String, password: String) -> String {
    Data("\(email):\(password)".utf8).base64EncodedString()
}
