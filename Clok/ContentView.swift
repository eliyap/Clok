//
//  ContentView.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var settings: Settings
    
    /// whether we're finished loading data
    @State var loaded = false
    
    /// whether we need user's token
    @State var needToken = false
    
    var body : some View {
        ZStack {
            HStack(spacing: 0) {
                if settings.tab != .settings {
                    SpiralStack()
                }
                CustomTabView()
            }
            .background(offBG())
            /// fade out loading screen when data is finished being requested
            if settings.user?.token == nil {
                TokenView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
            
//            if !loaded {
//                ProgressIndicator()
//                    .transition(.opacity)
//            }
        }
        .onReceive(self.settings.$user, perform: {
            // do nothing if token is nil (user is not logged in)
            guard let token = $0?.token else { return }
            
            
            // get workspace
            settings.space = WorkspaceManager.getChosen()!
            
            // request user data
            self.loadData(
                token: token,
                workspaceID: settings.space!.wid
            )
        })
        .onAppear {
            /// try to find user credentials
            if let user = getCredentials() {
                self.settings.user = user
            } else {
                print("could not retrieve user from disk")
            }
        }
    }
}
