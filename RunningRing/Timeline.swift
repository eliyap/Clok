//
//  RunningRingTimeline.swift
//  Clok
//
//  Created by Secret Asian Man 3 on 20.09.26.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Intents
import WidgetKit
import CoreData

/**
 Define the refresh rate centrally so it can be tweaked quickly
 */
fileprivate extension TimeInterval {
    static let widgetPeriod: TimeInterval = .hour / 6
    /// how often to request a redraw, in seconds
    /// turn up if the widget gets frozen by the OS
    static let redrawPeriod: TimeInterval = 180
}

struct Provider: IntentTimelineProvider {
    
    typealias Entry = RunningRingEntry
    typealias Intent = RunningRingConfigurationIntent
    
    var moc: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        moc = context
    }
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), entry: .noEntry)
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), entry: .noEntry)
        completion(entry)
    }

    func getTimeline(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        fetchRunningEntry(context: moc) { running, error in
            guard let running = running, error == nil else {
                print("RunningRingWidget Fetch Failed With Error \(String(describing: error))")
                let timeline = Timeline(entries: [Entry](), policy: .after(Date() + .widgetPeriod))
                completion(timeline)
                return
            }
            
            /// load again after `widgetPeriod`
            let timeline = Timeline(
                /// update every minute
                entries: (0..<Int(TimeInterval.widgetPeriod / .redrawPeriod)).map {
                    RunningRingEntry(
                        date: Date() + TimeInterval.redrawPeriod * Double($0),
                        entry: running
                    )
                },
                policy: .after(Date() + .widgetPeriod)
            )
            completion(timeline)
            return
        }
    }
}
