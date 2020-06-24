//
//  FilterButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FilterButton: View {
    let radius = CGFloat(10)

    var body: some View {
        Button(action: {
            
        }) {
            WeekButtonGlyph(name: "line.horizontal.3.decrease.circle")
                .padding([.leading, .trailing], buttonPadding)
        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton()
    }
}
