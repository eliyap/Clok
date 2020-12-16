//
//  DescriptionField.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 16/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// shield main view from changes until `onCommit` is called
struct DescriptionField: View {
    @Binding var description: String
    @State private var text: String = ""
    
    var body: some View {
        TextField("Description", text: $text, onCommit: {
            description = text
        })
            .font(.title)
            .onAppear{ text = description }
            .onChange(of: description) { text = $0 }
    }
}
