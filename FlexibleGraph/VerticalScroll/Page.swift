//
//  Page.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

// MARK:- Page
extension FlexibleGraph {
    /// Represents 1 Page in the InfiniteScroll column
    /// - Parameters:
    ///   - idx: the number of this page, determines which time period it renders
    ///   - size: the size of the page
    /// - Returns: `View`
    func Page(idx: Int, size: CGSize) -> some View {
        ZStack(alignment: .topLeading) {
            switch model.mode {
            case .dayMode:
                DayCalendar(size: size, idx: idx)
            case .listMode:
                DayList(entries: dataSource.entries[idx] ?? [])
                    .onAppear{
                        dataSource.load(for: idx)
                    }
            case .extendedMode:
                EmptyView()
            }
            StickyDateLabel(idx: idx)
        }
    }
}

import CoreData

final class DataSource: ObservableObject {
    @Published var entries = [Int:[TimeEntry]]()
    
    let context: NSManagedObjectContext
    var req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
    
    init(in context: NSManagedObjectContext) {
        self.context = context
        req.sortDescriptors = [NSSortDescriptor(key: "lastIndexed", ascending: true)]
        req.returnsObjectsAsFaults = false
    }
    
    func load(for idx: Int) -> Void {
        for idx in [idx - 1, idx + 1] {
            #warning("TODO: load before and after, unless already loaded")
            /// if already loaded, move on
            if entries.keys.contains(idx) {
                continue
            }
            
            let start = Date().midnight.advanced(by: Double(idx) * .day)
            req.predicate = NSPredicate(format: "(start > %@) AND (start < %@)", NSDate(start), NSDate(start + .day))
            do {
                entries[idx] = try context.fetch(req) as? [TimeEntry]
            } catch {
                assert(false, "Failed to fetch TimeEntries!")
            }
            #warning("TODO: perform cleanup work for old stuff")
        }
    }
    
    #warning("TODO: purge rolls on backgrounding")
}
