//
//  AppView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

@main
struct ClokApp: App {
    
    var listRow = ListRow()
    var zero = ZeroDate()
    var data = TimeData()
    var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listRow)
                .environmentObject(zero)
                .environmentObject(data)
                .environmentObject(settings)
                .border(Color.red)
        }
        
    }
}
