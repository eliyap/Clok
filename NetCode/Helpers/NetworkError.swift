//
//  NetworkError.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case request(error: NSError)
    case server
    case timeout
    case serialization
    case statusCode(code: Int)
    case other // bad practice, in future try to figure out how I can have some
    // generic error for handling non-network errors
}
