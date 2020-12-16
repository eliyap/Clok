//
//  APIKeyHandler.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/**
 Load the user's login credentials from local KeyChain, if any
 */
func loadCredentials() -> User? {
    do {
        let (email, fullname, apiKey, _) = try getKey()
        guard
            let spaces = WorkspaceManager.workspaces,
            let chosen = WorkspaceManager.chosenWorkspace
        else {
            return nil
        }
        return User(
            token: apiKey,
            email: email,
            name: fullname,
            spaces: spaces,
            chosen: chosen,
            firstDayOfWeek: WidgetManager.firstDayOfWeek
        )
    } catch KeychainError.unhandledError(code: errSecItemNotFound) {
        print("No Key Found")
    } catch KeychainError.unhandledError(code: let status) {
        print("Keychain error with OSStatus: \(status)")
    } catch {
        fatalError("Unexpected non KeyChain error: \(error)")
    }
    return nil
}

/**
 Write the `User`'s login credentials to local KeyChain
 */
func saveKeys(user: User) throws -> Void {
    
    /// User constructor guarantees >0 workspaces, but check anyway
    precondition(user.workspaces.count > 0, "Tried to save no workspaces!")
    
    /// save workspaces in user defaults
    WorkspaceManager.workspaces = user.workspaces
    
    /// default `chosenWorkspace` to 1st workspace
    WorkspaceManager.chosenWorkspace = user.workspaces.first!
    
    let keychainItem = [
        kSecAttrServer:  service,                        // secure Toggl login items:
        kSecAttrAccount: user.email,                     // email
        kSecAttrCreator: user.fullName,                  // full name
        kSecValueData:   user.token.data(using: .utf8)!, // token
        /**
         NOTE: workspace ID, strictly speaking, is not super sensitive data.
         It is stored here because it is a **required** field for toggl API requests.
         Thus it needs to be accessible by the Widget, which cannot access the UserDefaults of the main app,
         but *can* access the shared Keychain.
         */
        kSecAttrPort:    "\(user.chosen.wid)",           // workspace ID
        kSecClass:       kSecClassInternetPassword,
        kSecReturnData:  true
    ] as CFDictionary

    var ref: AnyObject?

    let status = SecItemAdd(keychainItem, &ref)
    
    /// handle result of operation
    switch status {
    case 0:
        break
    case -25299: /// duplicate item found
        break
    default:
        throw KeychainError.unhandledError(code: status)
    }
}

/// when user logs out, remove login credentials from the keychain
func dropKey() throws -> Void {
    let query = [kSecClass: kSecClassInternetPassword,
                 kSecAttrServer: service,
        ] as CFDictionary
    
    let status = SecItemDelete(query)
    
    if status != 0 {
        throw KeychainError.unhandledError(code: status)
    }
}
