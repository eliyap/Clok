//
//  ContentView.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var cred: Credentials
    
    /// whether we're finished loading data
    @State var loaded = false
    
    /// whether we need user's token
    @State var needToken = false
    var body : some View {
        /// ZStack replaces `fullScreenCover`, which was not flexible enough for my needs
        ZStack {
            OrientationView()
//            if !loaded {
//                ProgressIndicator()
//            }
            if cred.user?.token == nil {
                LoginView(loaded: $loaded)
                    .modifier(FullscreenModifier())
            }
        }
        /// update on change to either user or space
        .onReceive(cred.$user) { user in
            if let user = user {
                /// fetch projects when app is started
                data.projects = fetchProjects(
                    user: user,
                    context: moc
                )
                ?? loadProjects(context: moc)
                ?? []
                
                /// populate include list with all projects, and `noProject`
                data.terms.projects = data.projects + [StaticProject.noProject]
            }
        }
    }
}
