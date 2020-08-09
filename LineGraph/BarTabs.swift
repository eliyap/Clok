//
//  BarTabs.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI



struct BarTabs: View {
    
    private let listPadding = CGFloat(7)
    
    var body: some View {
        TabView{
            FilterView()
            EntryList(listPadding: listPadding)
            StatView()
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
