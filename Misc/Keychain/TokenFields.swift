//
//  TokenFields.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension TokenView {
    func TokenFields() -> some View {
        Group {
            TextField(
                "API Token",
                text: $key,
                onEditingChanged: edit,
                onCommit: {
                    self.loginWith(auth: auth(
                        token: self.key
                    ))
                }
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .transition(.upAndDown)
            
            HStack(spacing: .zero) {
                Text("Find Toggl's API Token on your ")
                Text("Profile")
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        UIApplication.shared.open(TokenView.profileURL)
                    }
            }
                .transition(.upAndDown)
        }
    }
}
