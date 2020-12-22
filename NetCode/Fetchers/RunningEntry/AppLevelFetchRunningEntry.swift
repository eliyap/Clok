//
//  AppLevelFetchRunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import Combine

extension ClokApp {
    /// accepts a meaningless boolean to satisfy it's need to be plugged into `onChanged`
    func fetchRunningEntry(_: Bool = false) -> Void {
        guard let user = cred.user else { return }
        RunningEntryLoader.fetchRunningEntry(
            user: user,
            projects: loadProjects(context: nspc.viewContext) ?? []
        )
            /// in production, allow this to fail the fetch silently
            .catch { (error: Error) -> AnyPublisher<RunningEntry, Never> in
                #if DEBUG
                assert(false, error.localizedDescription)
                #endif
                return Just(.noEntry).eraseToAnyPublisher()
            }
            .sink(receiveValue: { (running: RunningEntry) in
                #if DEBUG
                print(running == .noEntry ? "No Entry Running." : "Running: \(running.project.name), \(running.entryDescription)")
                #endif
                if !RunningEntry.widgetMatch(
                    WidgetManager.running,
                    running
                ) {
                    #if DEBUG
                    print("Difference Detected, Reloading Widget Timeline (Old: \(WidgetManager.running.project.name), \(WidgetManager.running.entryDescription))")
                    #endif
                    
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                /// save to `UserDefaults`
                WidgetManager.running = running
            })
            .store(in: &DataFetcher.shared.cancellable)
    }
}
