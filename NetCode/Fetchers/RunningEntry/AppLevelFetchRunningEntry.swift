//
//  AppLevelFetchRunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit

extension ClokApp {
    func fetchRunningEntry(_: Bool) -> Void {
        guard let user = cred.user else { return }
        #if DEBUG
        print("Fetching running timer")
        #endif
        RunningEntryLoader.fetchRunningEntry(
            user: user,
            projects: loadProjects(context: nspc.viewContext) ?? [],
            context: nspc.viewContext
        )
            .sink(receiveValue: { (running: RunningEntry?) in
                if !RunningEntry.widgetMatch(
                    WidgetManager.running,
                    running
                ) {
                    #if DEBUG
                    print("Difference Detected, Reloading Widget Timeline")
                    #endif
                    
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                /// save to `UserDefaults`
                WidgetManager.running = running
            })
            .store(in: &DataFetcher.shared.cancellable)
    }
}
