//
//  TokenView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


struct TokenView: View {
    
    enum loginPreference {
        case email
        case token
    }
    
    @State var email: String
    @State var password: String
    @State var key: String
    private var pref = loginPreference.email
    
    var body: some View {
        VStack {
            Text("Welcome")
            if pref == .email {
                TextField("Email", text: $key)
                TextField("Password", text: $key)
            } else if pref == .token {
                TextField("API Token", text: $key)
            }
            
        }
        
    }
}
