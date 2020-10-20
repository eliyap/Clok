//
//  RunningSquare.swift
//  RunningRingExtension
//
//  Created by Secret Asian Man Dev on 20/10/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct RunningSquare: View {
    
    let strokeWidth = CGFloat(5)
    
    var body: some View {
        ContainerRelativeShape()
            .stroke(Color(UIColor.systemGray6), style: StrokeStyle(lineWidth: strokeWidth))
    }
}
