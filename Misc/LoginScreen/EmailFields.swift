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
    
    func emailLogin() -> Void {
        guard email != "" && password != "" else {
            errorText = "Please both your email and password"
            return
        }
        
        loginWith(auth: auth(
            email: email,
            password: password
        ))
    }
}
