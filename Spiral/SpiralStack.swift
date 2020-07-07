//
//  SpiralStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/**
 Negative Padding permits complete overlap of areas, where ZStack failed
 - Important: ZStacking did *not* work, as the Time Strip layer grabbed touch focus,
 preventing the user from manipulating the handle
 */
struct SpiralStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                SpiralView()
                    .frame(width: geo.size.height, height:geo.size.height)
                    .padding(Edge.Set.bottom, -geo.size.height)
                SpiralControls()
                    .frame(width: geo.size.height, height: geo.size.height)
            }
//            LineGraph()
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
    }
}

struct SpiralStack_Previews: PreviewProvider {
    static var previews: some View {
        SpiralStack()
    }
}
