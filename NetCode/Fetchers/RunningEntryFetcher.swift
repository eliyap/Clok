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

extension DataFetcher {
    
    func fetchRunningEntry(
        context: NSManagedObjectContext,
        completion:@escaping (Result<RunningEntry, Error>) -> Void
    ){
        
        guard let token = try? getKey().2 else {
            completion(.failure(KeychainError.noData))
            return
        }
        
        let projects = loadProjects(context: context)
        
        URLSession.shared.dataTaskPublisher(for: formRequest(
            url: runningURL,
            auth: auth(token: token)
        ))
            .map(dataTaskMonitor)
            .tryMap { (data: Data) -> RunningEntry in
                return try RunningEntry(data: data, projects: projects ?? [])
                    ?? .noEntry
            }
            .sink(receiveCompletion: { completed in
                switch completed {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { running in
                completion(.success(running))
            })
            .store(in: &cancellable)
    }
}
