//
//  EntryLabelAlignment.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct AlignedLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            /** Another monstrous hack.
             1. SF Symbol Image matches text size (unlike `Circle` or other solutions that consume space greedily)
             2. "circle" has an aspect ratio of 1. `.aspectRatio(1)` did not work in my testing
             3. `.overlay()` centers the glyph within that space, faking a `.center` alignment
             */
            Image(systemName: "circle")
                .foregroundColor(.clear)
                .overlay(configuration.icon)
            
            configuration.title
        }
    }
}
