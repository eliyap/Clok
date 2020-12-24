//
//  Max1.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    /// ensure the request returns EXACTLY one result, if any
    /// useful to forcefully ensure we set the `fetchLimit` correctly
    func max1<T>(for request: NSFetchRequest<NSFetchRequestResult>) -> T? {
        try? { () throws -> T? in
            switch try self.count(for: request) {
            case 0:
                return .none
            case 1:
                return (try self.fetch(request) as! [T])[0]
            case let x:
                fatalError("Returned more than one result! (count: \(x))! Check your fetchLimit, which was \(request.fetchLimit)")
            }
        }() ?? .none
    }
}
