//
//  TopFunctions.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension ContentView {
    func tryLoadUserFromDisk() {
        /// try to find user credentials
        if let user = getCredentials() {
            cred.user = user
        } else {
            print("could not retrieve user from disk")
        }
    }
}
