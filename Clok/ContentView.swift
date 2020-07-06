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
            ContentGroupView()
            /// fade out loading screen when data is finished being requested
            if settings.user?.token == nil { LoginView() }
//            if !loaded { ProgressIndicator() }
        }
        .onReceive(self.settings.$user, perform: { fetchData($0) })
        .onAppear { tryLoadUserFromDisk() }
        .onAppear {
            testRunning()
        }
    }
}
