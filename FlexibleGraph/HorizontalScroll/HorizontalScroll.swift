//
//  HorizontalScroll.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    
    var HorizontalScroll: some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                AlignedTimeIndicator(height: geo.size.height)
                    .offset(y: -geo.size.height * rowPosition.position.y)
                    .gesture(DragGesture()
                        .onChanged { state in
                            rowPosition.position.y += state.translation.height / geo.size.height
                        }
                    )
                HorizontalScrollView
            }
        }
    }
}
