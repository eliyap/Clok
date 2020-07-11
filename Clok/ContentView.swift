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
    @FetchRequest(entity: TimeEntry.entity(), sortDescriptors: []) var myEntries: FetchedResults<TimeEntry>
    
    
    
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var settings: Settings
    
    /// whether we're finished loading data
    @State var loaded = false
    
    /// whether we need user's token
    @State var needToken = false
    var body : some View {
        ZStack {
            OrientationView()
            /// fade out loading screen when data is finished being requested
            
//            if !loaded { ProgressIndicator() }
            if settings.user?.token == nil { LoginView() }
        }
        /// update on change to either user or space
        .onReceive(settings.$user) {
            fetchData(user: $0)
        }
        .onAppear { tryLoadUserFromDisk() }
        .onAppear {
            testRunning()
        }
    }
}
