//
//  FilterStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FilterStack: View {
    @EnvironmentObject private var data: TimeData
    
    let buttonSize = glyphFrameSize + backgroundPadding * 2
    @State private var spacing = CGFloat.zero
    
    var body: some View {
        VStack(spacing: .zero) {
            ProjectButton()
                .padding(.bottom, spacing)
            Circle()
                .frame(width: buttonSize, height: buttonSize)
                .padding(.bottom, spacing)
            FilterButton()
        }
        .onReceive(data.$searching, perform: { searching in
            withAnimation(.linear(duration: 0.1)) {
                self.spacing = searching ? buttonPadding : -self.buttonSize
            }
        })
    }
}

struct FilterStack_Previews: PreviewProvider {
    static var previews: some View {
        FilterStack()
    }
}
