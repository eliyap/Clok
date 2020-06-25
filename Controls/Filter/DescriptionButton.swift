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
        HStack(spacing: .zero) {
            Image(systemName:
                /// no preference for description: wildcard!
                self.data.terms.byDescription == .any ? "asterisk.circle" :
                /// explicitly want blank description
                self.data.terms.byDescription == .empty ? "xmark.circle" :
                /// some description specified
                self.data.terms.byDescription == .specific ? "pencil.circle" : ""
                
            )
                .transition(.opacity)
                .modifier(ButtonGlyph())
                .onTapGesture { self.data.terms.byDescription.cycle() }
            
            Text("Description is ")
                .onTapGesture { self.data.terms.byDescription.cycle() }
            
            if data.terms.byDescription == .any {
                Text("Anything")
            } else if data.terms.byDescription == .empty {
                Text("Empty")
            } else if data.terms.byDescription == .specific {
                TextField("Description", text: self.$data.terms.description)
                    .padding(3)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary, lineWidth: 2)
                    )
            }
        }
    }
}
