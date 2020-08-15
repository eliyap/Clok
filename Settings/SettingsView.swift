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
    @EnvironmentObject var zero: ZeroDate
    @Environment(\.managedObjectContext) var moc
    
//    @State var weekday = WeekdayWrapper()
    @State var weekday: Int = WorkspaceManager.firstDayOfWeek
    
    var body: some View {
        NavigationView {
            List {
                AccountSection
                PrefsSection
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
            NavigationLink(destination: WorkspaceMenu()){
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
            NavigationLink(destination: WeekdaySelector(weekday: $weekday)){
                HStack {
                    Text("Week starts on")
                    Spacer()
                    Text(Calendar.current.weekdaySymbols[weekday - 1])
                }
            }
            .onChange(of: weekday, perform: updateWeekday)
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
    
    /**
     Log the user out of our app
     destroy all stored data tied to the user
     */
    func logOut() -> Void {
        /// destroy CoreData `TimeEntry`s
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try moc.execute(request)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
                                
        /// destroy credentials
        try! dropKey()
        
        /// destroy workspace records
        WorkspaceManager.workspaces = []
        WorkspaceManager.chosenWorkspace = Workspace(wid: 0, name: "")
        
        /// animate appearance of `LoginView`
        withAnimation {
            settings.user = nil
        }
    }
    
    func updateWeekday(weekday: Int) -> Void {
        /// update `UserDefaults`
        WorkspaceManager.firstDayOfWeek = weekday
        /// update `ZeroDate.start` to keep app in sync
        zero.start = zero.start.startOfWeek(day: weekday)
    }
}
