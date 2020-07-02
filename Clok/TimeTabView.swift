//
//  TimeTabView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TimeTabView: View {
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject private var settings: Settings
    @State private var openTab = 2
    
    enum tabs: Int {
        case entries = 1
        case summary = 2
        case settings = 3
    }
    
    var body: some View {
        TabView(selection: $settings.tab) {
            EntryList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Entries")
                }.tag(tabs.entries)
            StatView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }.tag(tabs.summary)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(tabs.settings)
        }
    }
}
