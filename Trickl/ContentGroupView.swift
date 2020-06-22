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
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                TimeStripView()
                    .padding(Edge.Set.bottom, negativePadding)
                ZStack{
                    SpiralUI()
                    SpiralControls()
                }
            }
            .frame(width: self.limit, height: self.limit)
            TimeTabView()
        }
    }
}
