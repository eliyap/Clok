//
//  NSMOC_StaticProject.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//  Method Adopted from https://cocoacasts.com/the-elegance-of-disposable-managed-object-contexts

import Foundation
import CoreData
extension NSManagedObjectContext {
    /// creates a temporary child `NSManagedObjectContext`.
    /// this context is for the purpose of spinning up temporary values, and should NOT be used to house user data.
    /// i.e. do not call `.save()` in this MOC
    func makeChildMOC() -> NSManagedObjectContext {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = self
        return moc
    }
}
