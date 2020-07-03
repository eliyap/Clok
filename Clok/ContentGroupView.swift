//
//  ContentGroupView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension GeometryProxy {
    enum orientation {
        case landscape
        case portrait
    }
    func orientation() -> orientation {
        size.height > size.width ? .portrait : .landscape
    }
}

struct ContentGroupView: View {
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        GeometryReader {
            if $0.orientation() == .landscape {
                HStack(spacing: 0) {
                    /// hide spiral when using settings
                    if settings.tab != .settings { SpiralStack() }
                    CustomTabView()
                }
            } else {
                VStack(spacing: 0) {
                    /// hide spiral when using settings
                    if settings.tab != .settings { SpiralStack() }
                    CustomTabView()
                }
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
