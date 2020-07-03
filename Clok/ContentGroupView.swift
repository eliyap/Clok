//
//  ContentGroupView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct ContentGroupView: View {
    
    @EnvironmentObject var bounds: Bounds
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        GeometryReader {
            if $0.orientation() == .landscape {
                HStack(spacing: 0) {
                    if settings.tab != .settings { SpiralStack() }
                    CustomTabView()
                }
                .onAppear { bounds.mode = .landscape }
            } else {
                VStack(spacing: 0) {
                    if settings.tab != .settings { SpiralStack() }
                    CustomTabView()
                }
                .onAppear { bounds.mode = .portrait }
            }
        }
        .background(offBG())
    }
}

struct ContentGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ContentGroupView()
    }
}
