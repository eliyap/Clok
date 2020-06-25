//
//  ByDescriptionButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// basically a gloryfied radio button
struct ByDescriptionButton: View {
    @EnvironmentObject private var data: TimeData
    
    var body: some View {
        HStack {
            Button(action: {
                self.data.terms.byDescription.toggle()
            }) {
                Image(systemName: self.data.terms.byDescription ? "largecircle.fill.circle" : "circle")
                    .modifier(ButtonGlyph())
            }
            Text("Filter by Description:")
        }
        
    }
}

struct ByDescriptionButton_Previews: PreviewProvider {
    static var previews: some View {
        ByDescriptionButton()
    }
}
