//
//  TokenWebView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import WebKit

struct TokenWebView: View {
    var body: some View {
        WebView()
    }
}

struct WebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
}
