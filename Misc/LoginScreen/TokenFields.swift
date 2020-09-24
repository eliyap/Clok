//
//  TokenFields.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension LoginView {
    var TokenFields: some View {
        Group {
            TextField(
                "API Token",
                text: $key,
                onEditingChanged: edit,
                onCommit: tokenLogin
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.inAndOut(edge: .bottom))
            
                Button {
                    showingWebView = true
                } label: {
                    Text("How to log in with a token")
                }
                .fullScreenCover(isPresented: $showingWebView) {
                    TokenWebView(presenting: $showingWebView)
                        .transition(.inAndOut(edge: .bottom))
                }
                .transition(.inAndOut(edge: .bottom))
        }
    }
    
    func tokenLogin() -> Void {
        guard key != "" else {
            errorText = "Please enter your API token"
            return
        }
        
        cred.fetchUser(
            auth: auth(token: key),
            completion: fetchOnLogin
        )
    }
}
