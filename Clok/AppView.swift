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
import WidgetKit

@main
struct ClokApp: App {
    
    /// App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Running Timer
    @StateObject var timer = AppTimer()
    
    /// EnvironmentObjects
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
    let prevNextIndexer: PrevNextIndexer
    
    var nspc: NSPersistentContainer
        
    init(){
        /// initialize `NSPersistentContainer`
        nspc = makeNSPC()
        
        /// set merge policy after load
        nspc.viewContext.mergePolicy = NSOverwriteMergePolicy
        
        /// pull `Project`s from CoreData
        data = TimeData(projects: loadProjects(context: nspc.viewContext) ?? [])
        
        /// pull `User` from KeyChain
        cred = Credentials(user: loadCredentials())
        
        /// attach Publishers to UserDefaults
        saver = PrefSaver(zero: zero, model: model, data: data)
        
        /// perform automatic indexing
        self.prevNextIndexer = PrevNextIndexer(in: nspc.viewContext)
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
                .environment(\.managedObjectContext, nspc.viewContext)
                /// update on change to either user or space
                /// also fires at app launch when user is logged in
                .onReceive(cred.$user) { user in
                    guard let user = user else { return }
                    #if DEBUG
                    print(user.email)
                    #endif
                    /// fetch projects and tags, discard results
                    projectLoader.loader = ProjectLoader.fetchProjects(user: user, context: nspc.viewContext)
                        .sink(receiveValue: { _ in })
                    tagLoader.loader = TagLoader.fetchTags(user: user, context: nspc.viewContext)
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
                        projects: loadProjects(context: nspc.viewContext) ?? [],
                        tags: loadTags(context: nspc.viewContext) ?? [],
                        context: nspc.viewContext
                    )
                })
                /// perform a fetch whenever a new window is opened
                .onAppear{ fetchRunningEntry() }
                /// request provisional `UserNotification` permission when the app is first launched
                .onAppear(perform: getProvisional)
                /// save to persistent storage when sent to background
                .onBackgrounded { _ in
                    do {
                        try nspc.viewContext.save()
                    } catch {
                        #if DEBUG
                        fatalError("Top Level NSPersistentContainer failed to save!")
                        #endif
                    }
                }
        }
            /// attach `RunningEntry` fetcher to App, not Window
            .onChange(of: timer.tick, perform: fetchRunningEntry)
    }
}
