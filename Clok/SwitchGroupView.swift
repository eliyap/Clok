//
//  ContentGroupView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ContentGroupView: View {
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var bounds: Bounds
    
    var geo: GeometryProxy
    
    var body: some View {
        Group {
            switch settings.tab {
            case .spiral:
                Text("Daily View Planned")
                    .frame(width: size(geo), height: size(geo))
            case .bar:
                BarStack()
                    .frame(width: size(geo), height: size(geo))
            case .settings:
                EmptyView()
            }
            CustomTabView()
        }
    }
    
    func size(_ geo: GeometryProxy) -> CGFloat {
        if bounds.mode == .landscape {
            /// take full height in landscape mode, on every device
            return geo.size.height
        } else  {
            /// in portrait, restrict to 60% height
            /// prevent tabview getting crushed when device aspect ratio is close to 1
            return min(
                geo.size.width,
                geo.size.height * 0.6
            )
        }
    }
}
