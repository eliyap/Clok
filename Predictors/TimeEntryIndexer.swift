//
//  TimeEntryIndexer.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData
import Combine

struct TimeEntryIndexer {
    
    let anyCancellable: AnyCancellable
    let context: NSManagedObjectContext
    
    /// how long to wait in seconds before performing another index operation
    static private let Interval: TimeInterval = 10
    
    init(in context: NSManagedObjectContext) {
        self.context = context
        self.anyCancellable = Timer
            .publish(every: Self.Interval, on: .main, in: .common)
            .autoconnect()
            .sink{ _ in
                Self.indexPrevNext(in: context)
                Self.indexRepresentative(in: context)
            }
    }
}
