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
    
    func fetchData(user: User?) {
        // do nothing if token is nil (user is not logged in)
        guard let user = user else { return }
        
        
    }
    
    
//    TOP LEVEL SANDBOX
    func testRunning() -> Void {
        
//        var project = OldProject.noProject
//        let sem = DispatchSemaphore(value: 0)
//        let token = "cfae5db4249b8509ca7671259598c2fb"
//        let pid = 158395089

        
        
    }
    
}
