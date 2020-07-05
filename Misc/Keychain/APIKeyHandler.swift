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
    case noData
    case unexpectedData
    case unhandledError(code: OSStatus)
}

func getCredentials() -> User? {
    do {
        let (email, fullname, apiKey) = try getKey()
        print("retrieved from keychain")
        if WorkspaceManager.getSpaces() == nil {
            print("but no workspace")
        }
        return User(
            token: apiKey,
            email: email,
            name: fullname,
            spaces: WorkspaceManager.getSpaces()
        )
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

func saveKeys(user: User) throws -> Void {
    
    // User constructor guarantees >0 workspaces, but check anyway
    if user.workspaces.count <= 0 {
        fatalError("Tried to save no workspaces!")
    }
    
    // save workspaces in user defaults
    WorkspaceManager.saveSpaces(user.workspaces)
    
    // choose 1st workspace by default.
    WorkspaceManager.saveChosen(user.workspaces.first!)
    print("workspaces ok")
    
    let keychainItem = [kSecAttrServer: service,       // secure Toggl login items:
        kSecAttrAccount: user.email,                   // email
        kSecAttrCreator: user.fullName,                // full name
        kSecValueData: user.token.data(using: .utf8)!, // token
        kSecClass: kSecClassInternetPassword,
        kSecReturnData: true
        ] as CFDictionary

    var ref: AnyObject?

    let status = SecItemAdd(keychainItem, &ref)
    
    // handle result of operation
    switch status {
    case 0:
        break
    case -25299: // duplicate item found
        break
    default:
        throw KeychainError.unhandledError(code: status)
    }
}

func getKey() throws -> (String, String, String) {
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
    let email = dic[kSecAttrAccount] as! String
    let keyData = dic[kSecValueData] as! Data
    let fullName = dic[kSecAttrCreator] as! String
    let apiKey = String(data: keyData, encoding: .utf8)!
    return (email, fullName, apiKey)
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
