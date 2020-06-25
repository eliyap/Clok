//
//  DescriptionButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DescriptionButton: View {
    @EnvironmentObject private var data: TimeData
    
    @State private var name = ""
    
    let radius = CGFloat(10)
    
    var body: some View {
        HStack {
            Image(systemName:
                self.data.terms.byDescription ? (
                    self.data.terms.description == "" ?
                        /// explicitly want blank description
                        "xmark.circle" :
                        /// some description specified
                        "ellipsis.circle"
                    ) :
                /// no preference for description
                "circle"
                
            )
                .modifier(ButtonGlyph())
            if data.terms.byDescription {
                TextField(
                    self.data.terms.byDescription ? "No Description" : "Any Description",
                    text: self.$data.terms.description
                )
                .padding(3)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
            } else {
                Text("Any Description")
                    .opacity(0.5)
            }
            
        }
    }
}
