//
//  BarTabs.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI



struct BarTabs: View {
    
    private let listPadding = CGFloat(10)
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var bounds: Bounds
    @AppStorage(
        "BarTab",
        store: UserDefaults(suiteName: WorkspaceManager.suiteName)
    ) private var tab: BarTab = .entryList
    
    enum BarTab: Int {
        case filter
        case entryList
        case stat
    }
    
    var body: some View {
        VStack(spacing: listPadding) {
            WeekTitle
            TabView(selection: $tab){
                FilterView(listPadding: listPadding)
                    .tag(BarTab.filter)
                EntryList(listPadding: listPadding)
                    .tag(BarTab.entryList)
                StatView(listPadding: listPadding)
                    .tag(BarTab.stat)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
    
    var WeekTitle: some View {
        if bounds.device == .iPhone && bounds.mode == .portrait {
            return Text(zero.weekString)
                .font(.title2)
                .bold()
                .padding(.top, listPadding / 2)
        } else {
            return Text(zero.weekString)
                .font(.title)
                .bold()
                .padding(.top, listPadding)
        }
    }
}
