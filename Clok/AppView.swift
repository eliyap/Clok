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
    var zero = ZeroDate()
    var data = TimeData()
    var settings = Settings()
    var bounds = Bounds()
    
    var persistentContainer: NSPersistentContainer
    
    init(){
        let container = NSPersistentContainer(name: "TimeEntryModel")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("\(error)") }
        }
        persistentContainer = container
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
    }
    
    /// keep track of the what has been fetched this session
    @State private var minLoaded = Date() - weekLength
    @State private var maxLoaded = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listRow)
                .environmentObject(zero)
                .environmentObject(data)
                .environmentObject(settings)
                .environmentObject(bounds)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .onReceive(zero.$date, perform: { date in
                    guard let user = settings.user else { return }
                    if date < minLoaded {
                        
                        _ = fetchEntries(
                            user: user,
                            from: minLoaded - weekLength,
                            to: minLoaded, context: persistentContainer.viewContext,
                            projects: data.projects
                        )
                        
                        minLoaded -= weekLength
                    }
                })
        }
        
    }
}
