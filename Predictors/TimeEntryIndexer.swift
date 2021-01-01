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
    let container: NSPersistentContainer
    
    /// how long to wait in seconds before performing another index operation
    static private let Interval: TimeInterval = 2
    
    init(in container: NSPersistentContainer) {
        self.container = container
        self.anyCancellable = Timer
            .publish(every: Self.Interval, on: .main, in: .common)
            .autoconnect()
            .sink{ _ in
                /// perform tasks in the background
                #warning("disabled")
                let context = container.newBackgroundContext()
//                context.performAndWait { Self.indexPrevNext(in: context) }
//                context.performAndWait { Self.indexRepresentative(in: context) }
            }
    }
}
