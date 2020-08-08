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
    let size: CGSize
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var bounds: Bounds
    
    var body: some View {
        if bounds.mode == .landscape {
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
    
    var Views: some View {
        /// group prevents warning about underlying types
        Group {
            switch settings.tab {
            case .spiral:
                Text("Daily View Planned")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .bar:
                BarStack()
                    .frame(width: graphSize(size), height: graphSize(size))
                TabView{
                    EntryList()
                    StatView()
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            case .settings:
                SettingsView()
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
                    maxWidth: bounds.mode == .landscape ? nil : .infinity,
                    maxHeight: bounds.mode == .landscape ? .infinity : nil
                )
                .padding(buttonPadding)
        }
    }
    
    private func graphSize(_ size: CGSize) -> CGFloat {
        if bounds.mode == .landscape {
            /// take full height in landscape mode, on every device
            return size.height
        } else  {
            /// in portrait, restrict to 60% height
            /// prevent tabview getting crushed when device aspect ratio is close to 1
            return min(
                size.width,
                size.height * 0.6
            )
        }
    }
}
