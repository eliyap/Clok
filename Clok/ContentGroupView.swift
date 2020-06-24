//  ContentGroupView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct ContentGroupView: View {
    var heightLimit: CGFloat
    var widthLimit: CGFloat
    /**
     Permits Spiral to edge into the strip's area, increasing available size for the spiral.
     - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
     preventing the user from manipulating the handle
     */
    private let negativePadding = CGFloat(-30)
    
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                SpiralControls()
                    
                    .border(Color.red)
                ZStack{
                    SpiralUI()
                    KnobView()
                }
                    .frame(
                        width: min(self.widthLimit, self.heightLimit),
                        height: min(self.widthLimit, self.heightLimit)
                    )
                    .padding(Edge.Set.top, -heightLimit)
                    .border(Color.red)
                
            }
            .frame(width: self.widthLimit, height: self.heightLimit)
            TimeTabView()
        }
    }
}
