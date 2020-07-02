//
//  SpiralView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SpiralView: View {
    
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var settings: Settings
    @State var blurRadius = CGFloat.zero
    var size: CGFloat
    var body: some View {
        ZStack {
            SpiralUI()
            KnobView()
            if data.searching || settings.tab == .settings {
                /// increase contrast with filter text so it is more readable
                SearchContrastScreen()
            }
        }
            .blur(radius: blurRadius)
            .onReceive(data.$searching, perform: { searching in
                withAnimation{
                    self.blurRadius = searching ? 5 : .zero
                }
            })
            .frame(width: size, height:size)
            /**
             Permits overlap of areas
             - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
             preventing the user from manipulating the handle
             */
            .padding(Edge.Set.bottom, -size)
            /// turn off interaction when user is filtering / using settings
            .disabled(data.searching || settings.tab == .settings)

    }
}
