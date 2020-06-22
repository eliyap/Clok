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
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                TimeStripView()
                    .padding(Edge.Set.bottom, -30)
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
