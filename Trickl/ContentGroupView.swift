//
//  ContentGroupView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ContentGroupView: View {
    var limit: CGFloat
    /**
     Permits Spiral to edge into the strip's area, increasing available size for the spiral.
     - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
     preventing the user from manipulating the handle
     */
    private let negativePadding = CGFloat(-30)
    
    /**
     this unforgivably bad hack allows us to place the Time Strip *after* the Spiral
     while still keeping it vertically above, so that it renders over the spiral
     */
    private let flip = Angle(degrees: 180)
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                ZStack{
                    SpiralUI()
                    SpiralControls()
                }
                    .rotationEffect(flip)
                TimeStripView()
                    .padding(Edge.Set.bottom, negativePadding)
                    .rotationEffect(flip)
            }
            .rotationEffect(flip)
            .frame(width: self.limit, height: self.limit)
            TimeTabView()
        }
    }
}
