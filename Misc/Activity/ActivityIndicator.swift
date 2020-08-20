//
//  ActivityIndicator.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.31.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressIndicator: View {
    
    @Binding var loaded: Int
    @Binding var totalCount: Int
    
    var body: some View {
        VStack {
            ActivityIndicator()
            ProgressView(value: Double(loaded) / Double(totalCount), total: 1)
            Text("Downloading \(loaded) of \(totalCount) time entries...")
            
        }
            .padding()
            .modifier(FullscreenModifier())
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let uiView = UIActivityIndicatorView()
        uiView.startAnimating()
        return uiView
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        // Start and stop UIActivityIndicatorView animation
    }
}
