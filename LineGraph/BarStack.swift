//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    
    var body: some View {
        GeometryReader { geo in
            switch bounds.mode {
            case .landscape:
                HStack(spacing: 0) {
                    GraphView()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: geo.size.height, height: geo.size.height)
                        .layoutPriority(1)
                    Divider()
                    BarTabs()
                }
            case .portrait:
                VStack(spacing: 0) {
                    GraphView()
                        .frame(maxHeight: geo.size.height * 0.6)
                        .layoutPriority(1)
                    Divider()
                    BarTabs()
                }
            }
        }
    }
}
