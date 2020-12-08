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
                            
                            /// update time offset
                            rowPosition.position.y = dragInitial! - state.translation.height / geo.size.height
                            
                            /// bound time-offset within [0, 1]
                            if rowPosition.position.y > 1 {
                                dragInitial! -= 1
                                rowPosition.position.y -= 1
                                positionRequester.send(+1)
                            } else if rowPosition.position.y < 0 {
                                dragInitial! += 1
                                rowPosition.position.y += 1
                                positionRequester.send(-1)
                            }
                        }
                        .onEnded { state in
                            /// forget state in preparation for next Gesture
                            dragInitial = .none
                            
                            if rowPosition.position.y < GraphConstants.midnightSnapThreshhold {
                                withAnimation {
                                    rowPosition.position.y = 0
                                }
                            } else if rowPosition.position.y > (1 - GraphConstants.midnightSnapThreshhold) {
                                withAnimation {
                                    rowPosition.position.y = 1
                                }
                            }
                        }
                    )
                HorizontalScrollStack
            }
        }
    }
}
