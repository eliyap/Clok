//
//  TokenView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    /// allow this view to dismiss itself after user logs in
    @EnvironmentObject var cred: Credentials
    @EnvironmentObject var entryLoader: EntryLoader
    @EnvironmentObject var projectLoader: ProjectLoader
    
    /// direct users to their profile, where they can copy the API Token
    static let profileURL = URL(string: "https://toggl.com/app/profile")!
    
    enum loginPreference {
        case email
        case token
    }
    
    @State var email = ""
    @State var password = ""
    @State var key = ""
    @State var errorText = ""
    @State private var pref: loginPreference = .email
    @State private var pushup = false
    
    @Binding var loaded: Bool
    
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
                
                if errorText != "" {
                    Text(errorText)
                        .foregroundColor(.red)
                }
                
                switch pref {
                case .email:
                    EmailFields
                case .token :
                    TokenFields
                }
                
                /// dummy view that ensures textField isn't masked by software keyboard
                /// EmptyView didn't work
                if pushup {
                    Text(" ")
                        .frame(maxHeight: UIScreen.main.bounds.size.height / 2)
                        .transition(.inAndOut(edge: .bottom))
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
    
    /**
     On first login, execute a special call that fetches `User`'s projects and many weeks of entries.
     This helps ensure the user won't encounter a lot of blank screens.
     */
    func fetchOnLogin(user: User) -> Void {
        /// request projects
        projectLoader.fetchProjects(user: user, context: moc) { projects in
            /// then use fresh projects when requesting entries
            entryLoader.fetchEntries(
                range: (
                    /// grab a year's worth of work (should be enough for most users)
                    start: Date() - (.day * 365),
                    end: Date()
                ),
                user: user,
                projects: projects,
                context: moc,
                /// indicate that a loading screen SHOULD be shown
                initialLogin: true
            )
        }
    }
}
