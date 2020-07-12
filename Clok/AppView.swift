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
            if let error = error {
                fatalError("persistence load failed")
            }
        }
        self.persistentContainer = container
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listRow)
                .environmentObject(zero)
                .environmentObject(data)
                .environmentObject(settings)
                .environmentObject(bounds)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
        
    }
}
