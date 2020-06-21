//
//  ContentGroupView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ContentGroupView: View {
    var width: CGFloat
    
    var body: some View {
        Group {
            ZStack{
                SpiralUI()
                SpiralControls()
            }
            .frame(width: self.width * 0.60)
            TimeTabView()
        }
    }
}
