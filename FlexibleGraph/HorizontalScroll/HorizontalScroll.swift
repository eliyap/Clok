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
                AlignedTimeIndicator(height: geo.size.height, rowY: rowPosition.position.y)
                    .gesture(DragGesture()
                        .onChanged { state in
                            /// if Gesture just started, store old value
                            if dragInitial == .none {
                                dragInitial = rowPosition.position.y
                            }
                            rowPosition.position.y = dragInitial! - state.translation.height / geo.size.height
                        }
                        .onEnded { state in
                            /// forget state in preparation for next Gesture
                            dragInitial = .none
                        }
                    )
                HorizontalScrollStack
            }
        }
    }
}
