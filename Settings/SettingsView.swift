//
//  SettingsView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    Text("Logged in as")
                    Text("Workspace")
                    
                }
                Section(header: EmptyView()) {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .onTapGesture {
                            // perform logout here
                        }
                    
                }
            }
            .modifier(roundedList())
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
