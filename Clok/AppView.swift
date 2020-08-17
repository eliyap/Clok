//
//  AppView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

@main
struct ClokApp: App {
    
    var listRow = ListRow()
    var zero = ZeroDate()
    var data: TimeData
    var cred: Credentials
    var bounds = Bounds()
    var model = GraphModel()
    
    /// pipeline for making Detailed Report requests
    var entryLoader: AnyCancellable? = nil
    
    var persistentContainer: NSPersistentContainer
    
    init(){
        /// initialize Core Data container
        let container = NSPersistentContainer(name: "TimeEntryModel")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("\(error)") }
        }
        persistentContainer = container
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        
        /// pull `Project`s from CoreData
        data = TimeData(projects: loadProjects(context: persistentContainer.viewContext) ?? [])
        
        /// pull `User` from KeyChain
        cred = Credentials(user: loadCredentials())
        
        /// refresh project list on launch
        data.fetchProjects(user: cred.user, context: persistentContainer.viewContext)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listRow)
                .environmentObject(zero)
                .environmentObject(data)
                .environmentObject(cred)
                .environmentObject(bounds)
                .environmentObject(model)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .onReceive(zero.objectWillChange) {
                    loadData(date: zero.start)
                }
                /// update on change to either user or space
                .onReceive(cred.$user) {
                    data.fetchProjects(
                        user: $0,
                        context: persistentContainer.viewContext
                    )
                }
        }
    }
    
    /// keep track of the what has been fetched this session
    @State private var minLoaded = Date()
    @State private var maxLoaded = Date()
    
    func loadData(date: Date) -> Void {
        /// ensure user is logged in
        guard let user = cred.user else { return }
        /// if data is old
        if date < minLoaded {
            /// fetch another week's worth from online
            data.newLoadEntries(
                start: minLoaded - .week,
                end: minLoaded,
                user: user,
                context: persistentContainer.viewContext
            )
            /// update our date range
            minLoaded -= .week
        }
    }
}
