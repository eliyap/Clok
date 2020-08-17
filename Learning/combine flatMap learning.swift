import Foundation
import Combine


let intPublisher = [1,2,3].publisher

let goal = 100
let goalPublisher = Just(goal)

func createFuturePublisher(val: Int, add: Int) -> AnyPublisher<Int, Never> {
    print("Total is: \(val)")
    print("Rolled a \(add)")
    let total = val + add
    guard add != 1 else {
        print("Rolled a 1, critical fail!")
        return Empty<Int, Never>()
            .eraseToAnyPublisher()
    }
    guard goal > total else {
        print("Goal Reached!")
        return Empty<Int, Never>()
            .eraseToAnyPublisher()
    }
    return createFuturePublisher(val: total, add: .random(in: 1...6))
        .eraseToAnyPublisher()
}

goalPublisher
    .flatMap { _ in
        createFuturePublisher(val: 0, add: 0)
    }
    .sink(receiveValue: {
        print($0)
    })
