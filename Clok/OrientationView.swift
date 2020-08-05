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
    @EnvironmentObject var zero: ZeroDate
    @Environment(\.verticalSizeClass) var vSize: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var hSize: UserInterfaceSizeClass?
    
    var body: some View {
        GeometryReader { geo in
            switch geo.orientation() {
            case .landscape:
                HStack(spacing: 0) { ContentGroupView(geo: geo) }
                    .onAppear {
                        bounds.mode = .landscape
                        bounds.insets = geo.safeAreaInsets
                    }
            case .portrait:
                VStack(spacing: 0) { ContentGroupView(geo: geo) }
                    .onAppear {
                        bounds.mode = .portrait
                        bounds.insets = geo.safeAreaInsets
                    }
            }
        }
        .background(Color.clokBG.edgesIgnoringSafeArea(.all))
        .onAppear {
            /// determine device
            bounds.device = (vSize == .compact || hSize == .compact) ? .iPhone : .iPad
            switch bounds.device {
            case .iPhone:
                /// limit smaller screen to 2 weeks
                zero.countMax = 14
            case .iPad:
                zero.countMax = 31
            }
        }
    }
}
