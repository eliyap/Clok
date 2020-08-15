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
        cred = Credentials(user: getCredentials())
        
        /// refresh project list on launch
        fetchProjects(user: cred.user)
        
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
                .onReceive(cred.$user, perform: fetchProjects)
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
    
    func fetchProjects(user: User?) -> Void {
        guard let user = user else { return }
        data.projectsPipe = URLSession.shared.dataTaskPublisher(for: formRequest(
            /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
            url: URL(string: "\(API_URL)/workspaces/\(user.chosen.wid)/projects?user_agent=\(user_agent)")!,
            auth: auth(token: user.token)
        ))
        .map { $0.data }
        .decode(
            type: [Project]?.self,
            /// pass `managedObjectContext` to decoder so that a CoreData object can be created
            decoder: JSONDecoder(context: persistentContainer.viewContext)
        )
        .replaceError(with: nil)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: {
            /// if there was an error and nothing came through, do not edit the data
            /// NOTE: if we correctly received 0 `Project`s (for some reason), this should correctly wipe the `Project`s in CoreData
            guard let projects = $0 else { return }
            data.projects = projects
            /// save newly created CoreData objects
            try! persistentContainer.viewContext.save()
        })
    }
}
