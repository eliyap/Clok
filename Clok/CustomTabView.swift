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
        if bounds.mode == .portrait {
            VStack {
                VStack(spacing: 0) { TabContents }
                HStack(spacing: 0) { TabButtons }
            }
        }
        else if bounds.device == .iPad && bounds.mode == .landscape {
            VStack {
                HStack(spacing: 0) { TabContents }
                HStack(spacing: 0) { TabButtons }
            }
        }
        else if bounds.device == .iPhone && bounds.mode == .landscape {
            HStack {
                HStack(spacing: 0) { TabContents }
                VStack(spacing: 0) { TabButtons }
            }
        }
    }
    
    var TabContents: some View {
        /// group prevents warning about underlying types
        Group {
            switch settings.tab {
            case .spiral:
                Text("Daily View Planned")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .bar:
                BarStack()
            case .settings:
                SettingsView()
            }
        }
    }
    
    var TabButtons: some View {
        Group {
            TabButton(select: .spiral, glyph: "arrow.counterclockwise")
            TabButton(select: .bar, glyph: "chart.bar.fill")
            TabButton(select: .settings, glyph: "gear")
        }
    }
    
    fileprivate let buttonPadding = CGFloat(8)
    func TabButton(select: Settings.Tabs, glyph: String) -> some View {
        let iPhoneLandscape = bounds.device == .iPhone && bounds.mode == .landscape
        return Button { settings.tab = select } label: {
            Label("", systemImage: glyph)
                .foregroundColor(settings.tab == select ? .primary : .secondary)
                .font(Font.body.weight(settings.tab == select ? .bold : .regular))
                .frame(
                    maxWidth: iPhoneLandscape ? nil : .infinity,
                    maxHeight: iPhoneLandscape ? .infinity : nil
                )
                .padding(buttonPadding)
        }
    }
}
