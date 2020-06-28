//
//  ContentView.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var data: TimeData
    
    /// indicates whether we are finished loading data
    @State var loaded = false
    
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
//            if !loaded {
//                ProgressIndicator()
//                    .transition(.opacity)
//            }
        }
        .onAppear {
            /// load data immediately
//            self.loadData()
//            self.getWorkspaceIDs()
//            let saveSuccessful: Bool = KeychainWrapper.standard.set("thisisatestkey", forKey: "TogglAPIKey")
//            let retrievedString: String? = KeychainWrapper.standard.string(forKey: "TogglAPIKey")
//            print(retrievedString)
        }
    }
}
