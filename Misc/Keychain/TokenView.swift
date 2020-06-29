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
    /// direct users to their profile, where they can copy the API Token
    static let profileURL = URL(string: "https://toggl.com/app/profile")!
    
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
                .padding()
            VStack {
                Text("Log in to Toggl")
                Picker(selection: $pref.animation(), label: EmptyView()) {
                    Text("Email").tag(loginPreference.email)
                    Text("Token").tag(loginPreference.token)
                }
                .pickerStyle(SegmentedPickerStyle())
                if pref == .email {
                    TextField(
                        "Email",
                        text: $email,
                        onEditingChanged: edit
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.upAndDown)
                    SecureField(
                        "Password",
                        text: $password,
                        onCommit: {
                            self.loginWith(auth: auth(email: self.email, password: self.password))
                        }
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.upAndDown)
                }
                else if pref == .token {
                    TextField(
                        "API Token",
                        text: $key,
                        onEditingChanged: edit,
                        onCommit: {
                            self.loginWith(auth: auth(token: self.key))
                        }
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.upAndDown)
                    TokenLink()
                        .transition(.upAndDown)
                }
                /// dummy view that ensures textField isn't masked by keyboard on iOS
                /// EmptyView didn't work
                if pushup {
                    Text(" ")
                        .frame(maxHeight: UIScreen.height / 2)
                        .transition(.upAndDown)
                }
            }
            /// prevent 's picker from munching the whole screen
            .frame(maxWidth: UIScreen.main.bounds.size.width / 2)
        }
    }
    
    /// when user starts / stops editing text field, raise / lower the pushup view
    func edit(_ editing: Bool) -> () {
        withAnimation {
            pushup = editing
        }
    }
    
    func TokenLink() -> some View {
        HStack(spacing: .zero) {
            Text("Find Toggl's API Token on your ")
            Text("Profile")
                .foregroundColor(Color.blue)
                .onTapGesture {
                    UIApplication.shared.open(TokenView.profileURL)
                }
        }
    }
    
    func loginWith(auth: String) -> Void {
        print("attempting login")
        let request = formRequest(
            url: userDataURL,
            auth: auth
        )
        
        let result = getUserData(with: request)
        var user: User!
        switch result {
        case let .failure(error):
            print(error)
        case let .success(newUser):
            user = newUser
        }
        
        try! saveKeys(user: user)
        
    }
}
