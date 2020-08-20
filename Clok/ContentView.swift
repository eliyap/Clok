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
    @EnvironmentObject var entryLoader: EntryLoader
    @EnvironmentObject var cred: Credentials
    
    /// whether we're finished loading data
    @State var loaded = false
    
    /// whether we need user's token
    @State var needToken = false
    var body : some View {
        /// ZStack replaces `fullScreenCover`, which was not flexible enough for my needs
        ZStack {
            OrientationView()
            if entryLoader.loading {
                ProgressIndicator(
                    loaded: $entryLoader.loaded,
                    totalCount: $entryLoader.totalCount
                )
            }
            if cred.user?.token == nil {
                LoginView(loaded: $loaded)
                    .modifier(FullscreenModifier())
            }
        }
    }
}
