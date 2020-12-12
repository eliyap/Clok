//
//  PersistentContainer.swift
//  RunningRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.26.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData

func makeNSPC() -> NSPersistentContainer {
    /// initialize Core Data container
    let nspc = NSPersistentContainer(name: "TimeEntryModel")
    
    /// set store URL
    nspc.persistentStoreDescriptions = [NSPersistentStoreDescription(url: containerURL)]
    
    nspc.loadPersistentStores { description, error in
        if let error = error {
            #if DEBUG
            print((error as NSError).code)
            #endif
            fatalError("\(error as NSError)")
        }
    }
    
    return nspc
}
