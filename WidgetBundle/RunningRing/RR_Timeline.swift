//
//  RR_Timeline.swift
//  WidgetBundleExtension
//
//  Created by Secret Asian Man Dev on 29/10/20.
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

struct RunningRingProvider: IntentTimelineProvider {
    
    typealias Entry = RunningRingEntry
    typealias Intent = RunningRingConfigurationIntent
    
    var moc: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        moc = context
    }
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), entry: WidgetManager.running ?? .placeholder)
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        DataFetcher.shared.AssignCancellable(pub: RunningEntryRequest(context: moc)) { result in
            switch result {
            case .failure(let error):
                print("RunningRingWidget Fetch Failed With Error \(String(describing: error))")
                completion(placeholder(in: context))
            case .success(let running):
                completion(RunningRingEntry(date: Date(), entry: running))
            }
        }
    }

    func getTimeline(
        for configuration: Intent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        DataFetcher.shared.AssignCancellable(pub: RunningEntryRequest(context: moc)) { result in
            switch result {
            case .failure(let error):
                print("RunningRingWidget Fetch Failed With Error \(String(describing: error))")
                let timeline = Timeline(entries: [Entry](), policy: .after(Date() + .widgetPeriod))
                completion(timeline)
            case .success(let running):
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
            }
        }
    }
}
