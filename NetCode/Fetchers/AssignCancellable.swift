//
//  AssignCancellable.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

extension DataFetcher {
    /**
     Generic Function that joins a publisher and completion handler together
     */
    func AssignCancellable<T>(
        pub: AnyPublisher<T, Error>,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Void {
        pub.sink(receiveCompletion: { completed in
            switch completed {
            case .finished:
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }, receiveValue: { val in
            completion(.success(val))
        })
        .store(in: &cancellable)
    }
}
