//
//  CustomTabView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct CustomTabView: View {
    enum Tabs {
        case entries
        case summary
        case settings
    }
    
    @State private var selection = Tabs.summary
    
    var body: some View {
        HStack {
            switch selection {
            case .entries:
                Text("Entries")
            case .summary:
                Text("Summary")
            case .settings:
                Text("Settings")
            }
            Text("Hello World")
            VStack {
                TabButton(select: .entries, glyph: "list.bullet")
                TabButton(select: .summary, glyph: "chart.bar.fill")
                TabButton(select: .settings, glyph: "gear")
            }
        }
    }
    
    func TabButton(select: Tabs, glyph: String) -> some View {
        Button {
            selection = select
        } label: {
            Image(systemName: glyph)
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
