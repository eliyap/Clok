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
    func EmailFields() -> some View {
        Group {
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
                    guard email != "" && password != "" else {
                        errorText = "Please both your email and password"
                        return
                    }
                    
                    self.loginWith(auth: auth(
                        email: email,
                        password: password
                    ))
                }
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.upAndDown)
        }
    }
}
