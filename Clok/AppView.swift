//
//  AppView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData

@main
struct ClokApp: App {
    
    var listRow = ListRow()
    var zero: ZeroDate
    var data = TimeData()
    var settings = Settings()
    var bounds = Bounds()
    var model = GraphModel()
    
    var persistentContainer: NSPersistentContainer
    
    init(){
        zero = ZeroDate(start: Date().startOfWeek(day: WorkspaceManager.firstDayOfWeek))
        
        let container = NSPersistentContainer(name: "TimeEntryModel")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("\(error)") }
        }
        persistentContainer = container
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
    }
    
    /// keep track of the what has been fetched this session
    @State private var minLoaded = Date()
    @State private var maxLoaded = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listRow)
                .environmentObject(zero)
                .environmentObject(data)
                .environmentObject(settings)
                .environmentObject(bounds)
                .environmentObject(model)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .onReceive(zero.$start, perform: loadData)
        }
    }
    
    func loadData(date: Date) -> Void {
        /// ensure user is logged in
        guard let user = settings.user else { return }
        /// if data is old
        if date < minLoaded {
            /// fetch another week's worth from online
            _ = fetchEntries(
                user: user,
                from: minLoaded - .week,
                to: minLoaded, context: persistentContainer.viewContext,
                projects: data.projects
            )
            /// update our date range
            minLoaded -= .week
            
            /// refresh global var
            if let freshEntries = loadEntries(from: .distantPast, to: .distantFuture, context: persistentContainer.viewContext) {
                data.entries = freshEntries
            }
            do {
                try persistentContainer.viewContext.save() /// save on main threads
            } catch {
                print(error)
            }
        }
    
    }
}
