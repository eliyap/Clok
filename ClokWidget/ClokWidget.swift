//
//  ClokWidget.swift
//  ClokWidget
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Foundation
import Intents

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct ClokWidgetEntryView : View {
    var entry: Provider.Entry
    private let token = "3302cfeeaf4aa0920422ee8f0a139fd7"
    var body: some View {
        Text("Hello Widgety World!")
            .onAppear {
                let request = formRequest(
                    url: userDataURL,
                    auth: auth(token: token)
                )
                DispatchQueue.main.async {
                    let result = getUserData(with: request)
                    var user: User!
                    
                    switch result {
                    case .failure(.statusCode(code: 403)):
                        print("Wrong Token / Password")
                        return
                    case let .failure(.statusCode(code: errorCode)):
                        print("Error \(errorCode): Could not login to Toggl")
                        return
                    case let .failure(error):
                        print(error)
                        return
                    case let .success(newUser):
                        user = newUser
                    }
                    
                    print(user.email)
                    print(user.token)
                }
            }
    }
}

@main
struct ClokWidget: Widget {
    private let kind: String = "ClokWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            ClokWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
