//
//  SettingsView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
import CoreData
import SwiftUI
import Combine

struct SettingsView: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var cred: Credentials
    @EnvironmentObject var zero: ZeroDate
    @Environment(\.managedObjectContext) var moc
    
    @State var weekday: Int = WidgetManager.firstDayOfWeek
    @State var weekdaySetter: AnyCancellable? = nil
    
    var body: some View {
        NavigationView {
            List {
                AccountSection
                PrefsSection
                LogOutSection
                NotificationSection()
                Button("STOP") {
                    let running = WidgetManager.running
                    guard running != .noEntry else { return }
                    TimeEntry.stop(id: running.id, with: cred.user!.token) { _ in
                        #warning("missing completion!")
                        /// should probably update my stuff here
                    }
                }
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
                Text(cred.user?.fullName ?? "No One")
            }
            NavigationLink(destination: WorkspaceMenu()){
                HStack {
                    Text("Workspace")
                    Spacer()
                    Text(cred.user?.chosen.name ?? "No Space")
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
        WidgetManager.firstDayOfWeek = 0
        WidgetManager.running = .noEntry
        
        /// animate appearance of `LoginView`
        withAnimation {
            cred.user = nil
        }
    }
    
    func updateWeekday(weekday: Int) -> Void {
        /// update `UserDefaults`
        WidgetManager.firstDayOfWeek = weekday
        
        if let token = cred.user?.token {
            putWeekday(weekday, token: token)
        }
        
        /// update `ZeroDate.start` to keep app in sync
        zero.start = zero.start.startOfWeek(day: weekday)
    }
}
