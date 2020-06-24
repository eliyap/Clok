//  ContentGroupView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct ContentGroupView: View {
    var heightLimit: CGFloat
    var widthLimit: CGFloat
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                ZStack{
                    SpiralUI()
                    KnobView()
                }
                    .blur(radius: buttonPadding)
                    .frame(
                        width: min(self.widthLimit, self.heightLimit),
                        height: min(self.widthLimit, self.heightLimit)
                    )
                    /**
                     Permits overlap of areas
                     - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
                     preventing the user from manipulating the handle
                     */
                    .padding(Edge.Set.bottom, -heightLimit)
                    
                SpiralControls()
            }
            .frame(width: self.widthLimit, height: self.heightLimit)
            TimeTabView()
        }
    }
}
