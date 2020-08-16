import Foundation
import Combine


let intPublisher = [1,2,3].publisher

let goalPublisher = Just(10)

func createFuturePublisher(val: Int, deduct: Int) -> AnyPublisher<Int, Never> {
    print("HP is: \(val)")
    print("Rolled a \(deduct)")
    let rem = val - deduct
    guard rem > 0 else {
        print("KO!")
        return Empty<Int, Never>()
            .eraseToAnyPublisher()
    }
    return createFuturePublisher(val: rem, deduct: .random(in: 1...6))
        .eraseToAnyPublisher()
}

goalPublisher
    .flatMap {
        createFuturePublisher(val: $0, deduct: 0)
    }
    .sink(receiveValue: {
        print($0)
    })
