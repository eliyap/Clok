import Foundation

/**
 Try to find all ordered sequences of positive integers that sum to some goal number
 e.g. for goal = 3
 - 1, 1, 1
 - 2, 1
 - 3
 */
let goal = 24
func solve(solution: [Int], limit: Int) -> Void {
    let remainder = goal - solution.reduce(0, +)
    guard remainder > 0 else {
        print(solution)
        return
    }
    precondition(limit > 0)
    var new_limit = min(remainder, limit)
    while (new_limit > 0) {
        solve(solution: solution + [new_limit], limit: new_limit)
        new_limit -= 1
    }
}

solve(solution: [], limit: goal)
