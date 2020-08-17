import Foundation
import Combine


let intPublisher = [1,2,3].publisher

let goal = 100
let goalPublisher = Just(goal)

func createFuturePublisher(vals: [Int], add: Int) -> AnyPublisher<[Int], Never> {
    let vals = vals + [add]
    let total = vals.reduce(0){ $0 + $1 }
    print("Total is: \(total)")
    print("Rolled a \(add)")
    
    guard add != 1 else {
        print("Rolled a 1, critical fail!")
        return Just(vals)
            .eraseToAnyPublisher()
    }
    guard goal > total else {
        print("Goal Reached!")
        return Just(vals)
            .eraseToAnyPublisher()
    }
    return createFuturePublisher(vals: vals, add: .random(in: 1...6))
        .eraseToAnyPublisher()
}

goalPublisher
    .flatMap { _ in
        createFuturePublisher(vals: [], add: 0)
    }
    .sink(receiveValue: {
        print($0)
    })
