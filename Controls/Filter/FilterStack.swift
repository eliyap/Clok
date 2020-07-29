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
        VStack(alignment: .leading) {
            if data.searching {
                Text("Filter Entries where")
                    .font(.title)
                    .bold()
                    .transition(.inAndOut(edge: .bottom))
                ProjectButton()
                    .transition(.inAndOut(edge: .bottom))
                DescriptionButton()
                    .transition(.inAndOut(edge: .bottom))
            }
            FilterButton()
        }
    }
}
