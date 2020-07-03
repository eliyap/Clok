//
//  FilterStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    
    static let fastLinear = Animation.linear(duration: 0.25)
    static var upAndDown: AnyTransition {
        return AnyTransition
            .move(edge: .bottom)
            .animation(fastLinear)
            .combined(with: AnyTransition
                .opacity
                .animation(fastLinear)
            )
    }
}

struct FilterStack: View {
    @EnvironmentObject private var data: TimeData
    
    let buttonSize = glyphFrameSize + backgroundPadding * 2
    @State private var spacing = CGFloat.zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if data.searching {
                Text("Filter Entries where")
                    .font(.title)
                    .bold()
                    .transition(.upAndDown)
                ProjectButton()
                    .transition(.upAndDown)
                DescriptionButton()
                    .transition(.upAndDown)
            }
            FilterButton()
        }
        /// don't pad vertically, week button already does that
        .padding([.leading, .trailing], buttonPadding)
    }
}

struct FilterStack_Previews: PreviewProvider {
    static var previews: some View {
        FilterStack()
    }
}
