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
            settings.user = user
        } else {
            print("could not retrieve user from disk")
        }
    }
    
    func fetchData(_ user: User?) {
        // do nothing if token is nil (user is not logged in)
        guard let token = user?.token else { return }
        
        // get workspace
        settings.space = WorkspaceManager.getChosen()!
        
        // request user data
//        self.loadData(
//            token: token,
//            workspaceID: settings.space!.wid
//        )
    }
}
