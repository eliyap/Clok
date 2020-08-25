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
    
    let listRow = ListRow()
    let zero = ZeroDate()
    let data: TimeData
    let cred: Credentials
    let bounds = Bounds()
    let model = GraphModel()
    
    /// other stuff
    let entryLoader = EntryLoader()
    let projectLoader = ProjectLoader()
    let tagLoader = TagLoader()
    let saver: PrefSaver
    
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
        
        /// attach Publishers to UserDefaults
        saver = PrefSaver(zero: zero, model: model, data: data)
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
                .environmentObject(entryLoader)
                .environmentObject(projectLoader)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                /// update on change to either user or space
                /// also fires at app launch when user is logged in
                .onReceive(cred.$user) { user in
                    guard let user = user else { return }
                    #if DEBUG
                    print(user.email)
                    #endif
                    /// fetch projects and tags, discard results
                    projectLoader.loader = ProjectLoader.fetchProjects(user: user, context: persistentContainer.viewContext)
                        .sink(receiveValue: { _ in })
                    tagLoader.loader = TagLoader.fetchTags(user: user, context: persistentContainer.viewContext)
                        .sink(receiveValue: { _ in })
                }
                .onReceive(zero.limitedStart, perform: { date in
                    #if DEBUG
                    print("Detailed report for \(date) requested")
                    #endif
                    guard let user = cred.user else { return }
                    entryLoader.fetchEntries(
                        /// NOTE: add a 1 day margin of safety on either side
                        range: (
                            start: date - .day,
                            end: date + .week + .day
                        ),
                        user: user,
                        projects: loadProjects(context: persistentContainer.viewContext) ?? [],
                        tags: loadTags(context: persistentContainer.viewContext) ?? [],
                        context: persistentContainer.viewContext
                    )
                })
        }
    }
}
