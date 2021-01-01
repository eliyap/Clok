//
//  CustomTabView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct CustomTabView: View {
    
    enum Tabs: Int {
        case spiral
        case predict
        case bar
        case settings
    }
    
    @EnvironmentObject private var cred: Credentials
    @EnvironmentObject private var bounds: Bounds
    @Environment(\.managedObjectContext) var moc
    @AppStorage(
        "MainTab",
        store: UserDefaults(suiteName: WorkspaceManager.suiteName)
    ) private var tab: Tabs = .bar

    
    var body: some View {
        if bounds.mode == .portrait {
            VStack(spacing: 0) {
                VStack(spacing: 0) { TabContents }
                Divider()
                HStack(spacing: 0) { TabButtons }
                    .background(Color.background.edgesIgnoringSafeArea(.bottom))
            }
        }
        else if bounds.device == .iPad && bounds.mode == .landscape {
            VStack(spacing: 0) {
                HStack(spacing: 0) { TabContents }
                Divider()
                HStack(spacing: 0) { TabButtons }
                    .background(Color.background)
            }
        }
        else if bounds.device == .iPhone && bounds.mode == .landscape {
            HStack(spacing: 0) {
                HStack(spacing: 0) { TabContents }
                Divider()
                VStack(spacing: 0) { TabButtons }
                    .background(Color.background)
            }
        }
    }
    
    var TabContents: some View {
        /// group prevents warning about underlying types
        Group {
            switch tab {
            case .spiral:
                FlexibleGraph(in: moc)
            case .predict:
                ClokTableView()
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
            TabButton(select: .predict, glyph: "play.circle.fill")
            TabButton(select: .bar, glyph: "chart.bar.fill")
            TabButton(select: .settings, glyph: "gear")
        }
    }
    
    fileprivate let buttonPadding = CGFloat(8)
    func TabButton(select: Tabs, glyph: String) -> some View {
        let iPhoneLandscape = bounds.device == .iPhone && bounds.mode == .landscape
        return Button { tab = select } label: {
            Label("", systemImage: glyph)
                .foregroundColor(tab == select ? .primary : .secondary)
                .font(Font.body.weight(tab == select ? .bold : .regular))
                .frame(
                    maxWidth: iPhoneLandscape ? nil : .infinity,
                    maxHeight: iPhoneLandscape ? .infinity : nil
                )
                .padding(buttonPadding)
        }
    }
}
