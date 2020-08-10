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
    
    var body: some View {
        TabView{
            FilterView(listPadding: listPadding)
            EntryList(listPadding: listPadding)
            StatView(listPadding: listPadding)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
