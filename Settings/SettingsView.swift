//
//  SettingsView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
import CoreData
import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var settings: Settings
    @State var selectingWorkspace = false
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            List {
                AccountSection
                LogOutSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var AccountSection: some View {
        Section(header: Text("Account")) {
            HStack {
                Text("Logged in as")
                Spacer()
                Text(settings.user?.fullName ?? "No One")
            }
            NavigationLink(
                destination: WorkspaceMenu(),
                isActive: $selectingWorkspace
            ){
                HStack {
                    Text("Workspace")
                    Spacer()
                    Text(settings.user?.chosen.name ?? "No Space")
                }
            }
        }
    }
    
    var PrefsSection: some View {
        Section(header: Text("Preferences")) {
            NavigationLink(
                destination: WorkspaceMenu(),
                isActive: $selectingWorkspace
            ){
                HStack {
                    Text("Workspace")
                    Spacer()
                    Text(settings.user?.chosen.name ?? "No Space")
                }
            }
        }
    }
    
    var LogOutSection: some View {
        Section(header: EmptyView()) {
            Text("Log Out")
                .foregroundColor(.red)
                .onTapGesture(perform: logOut)
        }
    }
}

// MARK:- Functions
extension SettingsView {
    func logOut() -> Void {
        // destroy local data
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try moc.execute(request)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
                                
        // destroy credentials
        try! dropKey()
        
        // destroy workspace records
        WorkspaceManager.workspaces = []
        WorkspaceManager.chosenWorkspace = Workspace(wid: 0, name: "")
        
        settings.user = nil
        print("logged out!")
    }
}
