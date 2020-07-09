//
//  ContentGroupView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct OrientationView: View {
    
    @EnvironmentObject var bounds: Bounds
    @Environment(\.verticalSizeClass) var vSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var hSize: UserInterfaceSizeClass?
    
    var body: some View {
        GeometryReader { geo in
            if geo.orientation() == .landscape {
                HStack(spacing: 0) { ContentGroupView(geo: geo) }
                .onAppear {
                    bounds.mode = .landscape
                    bounds.notch = hasNotch(geo)
                }
            } else {
                VStack(spacing: 0) { ContentGroupView(geo: geo) }
                .onAppear {
                    bounds.mode = .portrait
                    bounds.notch = hasNotch(geo)
                }
            }
        }
        .background(Color.clokBG.edgesIgnoringSafeArea(.all))
        .onAppear {
            /// determine device
            bounds.device = (vSize == .compact || hSize == .compact) ? .iPhone : .iPad
        }
    }
    
    func hasNotch(_ geo: GeometryProxy) -> Bool {
        return geo.safeAreaInsets.bottom > 0
    }
}
