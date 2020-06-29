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
    
    @State var email = ""
    @State var password = ""
    @State var key = ""
    @State private var pref: loginPreference = .email
    
    var body: some View {
        VStack {
            Image("")
//            app icon here?
            Text("Welcome")
            Text("Log in to Toggl")
                
            Picker(selection: $pref, label: EmptyView()) {
                Text("Email").tag(loginPreference.email)
                Text("Token").tag(loginPreference.token)
            }
            
            if pref == .email {
                TextField("Email", text: $key)
                TextField("Password", text: $key)
            } else if pref == .token {
                TextField("API Token", text: $key)
            }
            
        }
        .frame(maxWidth: UIScreen.height)
        
    }
}
