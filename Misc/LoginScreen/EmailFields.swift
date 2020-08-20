//
//  EmailFields.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension LoginView {
    var EmailFields: some View {
        Group {
            TextField(
                "Email",
                text: $email,
                onEditingChanged: edit
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.inAndOut(edge: .bottom))
            
            SecureField(
                "Password",
                text: $password,
                onCommit: emailLogin
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.inAndOut(edge: .bottom))
        }
    }
    
    private func emailLogin() -> Void {
        guard email != "" else {
            errorText = "Please enter your email"
            return
        }
        
        guard password != "" else {
            errorText = "Please enter your password"
            return
        }
        
        cred.fetchUser(
            auth: auth(email: email, password: password),
            completion: loadEntriesOnLogin
        )
    }
}
