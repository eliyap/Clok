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
        VStack(alignment: .leading, spacing: .zero) {
            if data.searching {
                Text("Filter Entries where")
                    .font(.title)
                    .padding(.bottom, spacing)
                    .transition(.opacity)
                ProjectButton()
                    .padding(.bottom, spacing)
                    .transition(.opacity)
                DescriptionButton()
                    .padding(.bottom, spacing)
                    .transition(.opacity)
            }
            FilterButton()
        }
        /// don't pad vertically, week button already does that
        .padding([.leading, .trailing], buttonPadding)
        .onReceive(data.$searching, perform: { searching in
            withAnimation(.linear(duration: 0.15)) {
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
