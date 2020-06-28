//
//  APIKeyHandler.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

let service = "https://toggl.com/"

enum KeychainError: Error {
    case unexpectedData
    case unhandledError(code: OSStatus)
}

func getCredentials() -> (String, Int)? {
    do {
        return try getKey()
    } catch KeychainError.unhandledError(code: errSecItemNotFound) {
        print("No Key Found")
    } catch KeychainError.unhandledError(code: let status) {
        print("Keychain error with OSStatus: \(status)")
    } catch {
        // no other error type should come through!
        fatalError()
    }
    return nil
}

func saveKey(workspace: Workspace, key: String) throws -> Void {
    let keychainItem = [kSecValueData: key.data(using: .utf8)!,
                        kSecAttrAccount: workspace.id,
                        kSecAttrServer: service,
                        kSecClass: kSecClassInternetPassword,
                        kSecReturnData: true
        ] as CFDictionary

    var ref: AnyObject?

    let status = SecItemAdd(keychainItem, &ref)
    guard status == 0 else {
        throw KeychainError.unhandledError(code: status)
    }
}

func getKey() throws -> (String, Int) {
    let query = [kSecClass: kSecClassInternetPassword,
                 kSecAttrServer: service,
                 kSecReturnAttributes: true,
                 kSecReturnData: true
        ] as CFDictionary

    var result: AnyObject?
    let status = SecItemCopyMatching(query, &result)
    
    guard status == 0 else {
        throw KeychainError.unhandledError(code: status)
    }
    
    // convert and return data
    let dic = result as! NSDictionary
    let workspaceID = dic[kSecAttrAccount] as! Int
    let keyData = dic[kSecValueData] as! Data
    let apiKey = String(data: keyData, encoding: .utf8)!
    return (apiKey, workspaceID)
}

/// when user logs out, remove token from the keychain
func dropKey() throws -> Void {
    let query = [kSecClass: kSecClassInternetPassword,
                 kSecAttrServer: service,
        ] as CFDictionary
    
    let status = SecItemDelete(query)
    
    if status != 0 {
        throw KeychainError.unhandledError(code: status)
    }
}
