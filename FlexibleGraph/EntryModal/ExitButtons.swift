//
//  ExitButtons.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 22/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ExitButtons: View {
    
    @ScaledMetric private var radius: CGFloat = 7
    
    let delete: () -> Void
    let save: () -> Void
    
    var body: some View {
        HStack {
            Button(action: delete) {
                ExitButtonLabel("Delete", "trash")
            }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .cornerRadius(radius)
            Button(action: save) {
                ExitButtonLabel("Save", "checkmark")
            }
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .cornerRadius(radius)
        }
            .padding(.horizontal)
    }
    
    private struct ExitButtonLabel: View {
        
        @ScaledMetric private var labelPadding: CGFloat = 7
        
        private let text: String
        private let image: String
        static private let font: Font = .caption
        
        init(_ text: String, _ image: String) {
            self.text = text
            self.image = image
        }
        
        var body: some View {
            HStack {
                Image(systemName: image)
                    .font(Self.font)
                Text(text)
                    .font(Self.font)
            }
                .padding(labelPadding)
        }
    }
}
