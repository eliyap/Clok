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
    
    /// allow this view to dismiss itself after user logs in
    @EnvironmentObject var settings: Settings
    
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
            IconView()
            VStack {
                Text("Log in to Toggl")
                Picker(selection: $pref.animation(), label: EmptyView()) {
                    Text("Email").tag(loginPreference.email)
                    Text("Token").tag(loginPreference.token)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                switch pref {
                case .email:
                    EmailFields()
                case .token :
                    TokenFields()
                }
                
                /// dummy view that ensures textField isn't masked by keyboard on iOS
                /// EmptyView didn't work
                if pushup {
                    Text(" ")
                        .frame(maxHeight: UIScreen.main.bounds.size.height / 2)
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
    
}
