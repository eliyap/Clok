//
//  MVVMListView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct MVVMListView: View {
    
    let entries: [TimeEntry]
    let isLoading: Bool
    let onScrollToBottom: () -> ()
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    EntriesList
                    if isLoading {
                        ActivityIndicator()
                    }
                }
            }
        }
    }
    
    var EntriesList: some View {
        ForEach(entries, id: \.id) { entry in
            EntryView(entry: entry)
                .onAppear {
                    if entries.last == entry {
                        onScrollToBottom()
                    }
                }
        }
    }
}

extension ContentView {
    final class ListViewModel: ObservableObject {
        
        
        @Published private(set) var state = State()
        
        func fetch(context: NSManagedObjectContext, user: User?) -> () -> () {
            guard let user = user else { return {} }
            let df = DateFormatter()
            let api_string = "\(REPORT_URL)details?" + [
                "user_agent=\(user_agent)",    // identifies my app
                "workspace_id=\(user.chosen.wid)", // provided by the User
                "since=\(df.string(from: Date() - weekLength))",
                "until=\(df.string(from: Date()))"
            ].joined(separator: "&")
            return {
                entryRequest(
                    api_string: api_string,
                    page: 0,
                    token: user.token,
                    context: context
                )
                    .sink(receiveCompletion: { print($0) }, receiveValue: { print($0.count) })
            }
        }
        
        
        struct State {
            var entries = [TimeEntry]()
            var canLoadNextPage = true
        }
    }

}

func entryRequest(
    api_string: String,
    page: Int,
    token: String,
    context: NSManagedObjectContext
) -> AnyPublisher<[RawTimeEntry], Error> {
    URLSession.shared
        .dataTaskPublisher(for: formRequest(
            url: URL(string: api_string + "&page=\(page)")!,
            auth: auth(token: token)
        ))
        .tryMap {
            let decoder = JSONDecoder(context: context)
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Report.self, from: $0.data).entries
        }
        .eraseToAnyPublisher()
}
