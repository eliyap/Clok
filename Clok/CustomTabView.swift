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
        HStack(spacing: 0) {
            switch selection {
            case .entries:
                EntryList()
            case .summary:
                StatView()
            case .settings:
                SettingsView()
            }
            VStack {
                Spacer()
                TabButton(select: .entries, glyph: "list.bullet")
                    
                Spacer()
                TabButton(select: .summary, glyph: "chart.bar.fill")
                    
                Spacer()
                TabButton(select: .settings, glyph: "gear")
                    
                Spacer()
            }
        }
    }
    
    func TabButton(select: Tabs, glyph: String) -> some View {
        Button {
            selection = select
        } label: {
            Label("", systemImage: glyph)
        }
        .frame(alignment: .leading)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
