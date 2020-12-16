//
//  RR_Fetcher.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

/// Publishers employed by widgets

func RunningEntryRequest(context: NSManagedObjectContext) -> AnyPublisher<RunningEntry, Error> {
    guard let token = try? getKey().2 else {
        return Fail(error: KeychainError.noData)
            .eraseToAnyPublisher()
    }
    
    let projects = loadProjects(context: context)
    
    return URLSession.shared.dataTaskPublisher(for: formRequest(
        url: runningURL,
        auth: auth(token: token)
    ))
        .map(dataTaskMonitor)
        .tryMap { (data: Data) -> RunningEntry in
            return try RunningEntry(data: data, projects: projects ?? [])
                ?? .noEntry
        }
        .eraseToAnyPublisher()
}

func RawRunningEntryRequest() -> AnyPublisher<RawRunningEntry, Error> {
    guard let token = try? getKey().2 else {
        return Fail(error: KeychainError.noData)
            .eraseToAnyPublisher()
    }
    return URLSession.shared.dataTaskPublisher(for: formRequest(
        url: runningURL,
        auth: auth(token: token)
    ))
        .map(dataTaskMonitor)
        .tryMap {
            return try JSONDecoder(dateStrategy: .iso8601)
                .decode(RawRunningEntry.self, from: $0)
        }
        .eraseToAnyPublisher()
}
