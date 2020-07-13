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
    @State var selectingWorkspace = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    HStack {
                        Text("Logged in as")
                        Spacer()
                        Text(settings.user?.fullName ?? "No One")
                    }
                    NavigationLink(
                        destination: WorkspaceMenu(dismiss: $selectingWorkspace),
                        isActive: $selectingWorkspace
                    ){
                        HStack {
                            Text("Workspace")
                            Spacer()
                            Text(settings.user?.chosen.name ?? "No Space")
                        }
                    }
                    
                }
                Section(header: EmptyView()) {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .onTapGesture {
                            // destroy local data
                            #warning("need to destoy local storage")
//                            data.report = Report.empty
                            
                            // destroy credentials
                            try! dropKey()
                            
                            // destroy workspace records
                            WorkspaceManager.saveSpaces([])
                            WorkspaceManager.saveChosen(Workspace(wid: 0, name: ""))
                            
                            settings.user = nil
                            print("logged out!")
                        }
                }
            }
            .modifier(roundedList())
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
