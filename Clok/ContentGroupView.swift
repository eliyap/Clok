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
    @Environment(\.verticalSizeClass) var vSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var hSize: UserInterfaceSizeClass?
    
    var body: some View {
        GeometryReader { geo in
            if geo.orientation() == .landscape {
                HStack(spacing: 0) {
                    if settings.tab != .settings {
                        SpiralStack()
                            .frame(width: size(geo), height: size(geo))
                    }
                    CustomTabView()
                }
                .onAppear {
                    bounds.mode = .landscape
                    bounds.notch = hasNotch(geo)
                }
            } else {
                VStack(spacing: 0) {
                    if settings.tab != .settings {
                        SpiralStack()
                            .frame(width: size(geo), height: size(geo))
                    }
                    CustomTabView()
                }
                .onAppear {
                    bounds.mode = .portrait
                    bounds.notch = hasNotch(geo)
                }
            }
        }
        .background(offBG())
        .onAppear {
            /// determine device
            bounds.device = (vSize == .compact || hSize == .compact) ? .iPhone : .iPad
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
    
    func hasNotch(_ geo: GeometryProxy) -> Bool {
        return geo.safeAreaInsets.bottom > 0
    }
}

struct ContentGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ContentGroupView()
    }
}
