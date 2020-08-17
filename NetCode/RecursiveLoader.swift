//
//  RecursiveLoader.swift
//  Clok
//
// Based on:
// https://www.donnywals.com/recursively-execute-a-paginated-network-call-with-combine/

import Foundation
import Combine

struct Response {
    var hasMorePages = true
    var items = [Item(), Item()]
    var nextPageIndex = 0
}

struct Item {}

class RecursiveLoader {
    init() { }

    private func loadPage(withIndex index: Int) -> AnyPublisher<Response, Never> {
        // this would be the individual network call
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                let nextIndex = index + 1
                if nextIndex < 5 {
                    return promise(.success(Response(nextPageIndex: nextIndex)))
                } else {
                    return promise(.success(Response(hasMorePages: false)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadPages() -> AnyPublisher<[Item], Never> {
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(0)

        return pageIndexPublisher
            .flatMap({ index in
                return self.loadPage(withIndex: index)
            })
            .handleEvents(receiveOutput: { (response: Response) in
                if response.hasMorePages {
                    pageIndexPublisher.send(response.nextPageIndex)
                } else {
                    pageIndexPublisher.send(completion: .finished)
                }
            })
            .reduce([Item](), { allItems, response in
                return response.items + allItems
            })
            .eraseToAnyPublisher()
    }

}

