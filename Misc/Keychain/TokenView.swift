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
    @State var pushup = false
    var body: some View {
        HStack {
            Image("Icon")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 100, height: 100)

            VStack {
                
                Text("Welcome")
                Text("Log in to Toggl")
                    
                Picker(selection: $pref, label: EmptyView()) {
                    Text("Email").tag(loginPreference.email)
                    Text("Token").tag(loginPreference.token)
                }
                .pickerStyle(SegmentedPickerStyle())
                if pref == .email {
                    TextField(
                        "Email",
                        text: $email,
                        onEditingChanged: { isEditing in
                            withAnimation {
                                self.pushup = isEditing
                            }
                        }
                    )
                    TextField(
                        "Password",
                        text: $password,
                        onEditingChanged: { isEditing in
                            withAnimation {
                                self.pushup = isEditing
                            }
                        }
                    )
                } else if pref == .token {
                    TextField("API Token", text: $key)
                }
                if pushup {
                    /// dummy view, EmptyView didn't work
                    Text(" ")
                        .frame(maxHeight: UIScreen.height / 2)
                        .transition(.scale)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width / 2)
            .padding()

        }
    }
}
