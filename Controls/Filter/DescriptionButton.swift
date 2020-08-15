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
            #warning("may still need description filter later, but is currently dysfunctional")
//            Image(systemName:
//                /// no preference for description: wildcard!
//                data.terms.byDescription == .any ? "asterisk.circle" :
//                /// explicitly want blank description
//                data.terms.byDescription == .empty ? "xmark.circle" :
//                /// some description specified
//                data.terms.byDescription == .specific ? "pencil.circle" : ""
//            )
//                .transition(.opacity)
//                .modifier(ButtonGlyph())
//                .onTapGesture { data.terms.byDescription.cycle() }
//            
//            HStack(spacing: .zero) {
//                Text("Description is ")
//                    .onTapGesture { data.terms.byDescription.cycle() }
//                switch (data.terms.byDescription) {
//                case .any:
//                    Text("Anything")
//                case .empty:
//                    Text("Empty")
//                case .specific:
//                    TextField("Description", text: $data.terms.description)
//                        .padding(3)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//            }
        }
    }
}
