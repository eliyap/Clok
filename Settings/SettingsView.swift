//
//  SettingsView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var settings: Settings
    
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
                            // destroy local data
                            self.data.report = Report()
                            
                            // destroy credentials
                            try! dropKey()
                            
                            // destroy workspace records
                            WorkspaceManager.saveIDs([])
                            WorkspaceManager.saveChosen(id: 0)
                            
                            self.settings.token = nil
                            print("logged out!")
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
