//
//  KeychainError.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 6/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case noData
    case unexpectedData
    case unhandledError(code: OSStatus)
}

