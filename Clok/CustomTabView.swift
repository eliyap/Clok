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
        case spiral
        case bar
        case settings
    }
    
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var bounds: Bounds
    
    var body: some View {
        Group {
            if bounds.notch && bounds.mode == .landscape {
                HStack(spacing: 0) {
                    Views
                    VStack(spacing: 0) { Buttons }
                }
            } else {
                VStack(spacing: 0) {
                    Views
                    HStack(spacing: 0) { Buttons }
                }
            }
        }
    }
    
    var Views: some View {
        /// group prevents warning about underlying types
        Group {
            switch settings.tab {
            case .settings:
                SettingsView()
            default:
                TabView{
                    EntryList()
                    StatView()
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
    }
    
    var Buttons: some View {
        Group {
            TabButton(select: .spiral, glyph: "arrow.counterclockwise")
            TabButton(select: .bar, glyph: "chart.bar.fill")
            TabButton(select: .settings, glyph: "gear")
        }
    }
    
    private let buttonPadding = CGFloat(8)
    func TabButton(select: Settings.Tabs, glyph: String) -> some View {
        Button { settings.tab = select } label: {
            Label("", systemImage: glyph)
                .foregroundColor(settings.tab == select ? .primary : .secondary)
                .font(Font.body.weight(settings.tab == select ? .bold : .regular))
                .frame(
                    maxWidth: (bounds.notch && bounds.mode == .landscape) ? nil : .infinity,
                    maxHeight: (bounds.notch && bounds.mode == .landscape) ? .infinity : nil
                )
                .padding(buttonPadding)
        }
    }
}
