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
                VStack(spacing: 0) {
                    SpiralView()
                    SpiralControls()
                }
                .frame(width: UIScreen.height, height: UIScreen.height)
                TimeTabView()
            }
            .background(offBG())
            /// fade out loading screen when data is finished being requested
            if needToken {
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
        .onAppear {
            /// load data immediately
            if let (apiKey, workspaceID) = getCredentials() {
                self.loadData(token: apiKey, workspaceID: workspaceID)
            } else {
                self.needToken = true
            }
            
        }
    }
}
