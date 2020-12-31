//
//  DayList.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData

struct DayList: View {
    
    /// light / dark mode
    @Environment(\.colorScheme) var colorScheme
    
    let start: Date
    var entries: [TimeEntry] = []
    
    init(idx: Int, in context: NSManagedObjectContext) {
        self.start = Date().midnight.advanced(by: Double(idx) * .day)
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        /// **NOTE**: this filter EXCLUDES entries that started before midnight, to prevent `matchedGeometryEffect` duplicates
        req.predicate = NSPredicate(format: "(start > %@) AND (start < %@)", NSDate(start), NSDate(start + .day))
        req.sortDescriptors = [NSSortDescriptor(key: "lastIndexed", ascending: true)]
        do {
            self.entries = try context.fetch(req) as! [TimeEntry]
        } catch {
            assert(false, "Failed to fetch TimeEntries!")
        }
    }
    
    var body: some View {
        VStack {
            /// pushes the first entry clear of the `DateLabel`
            Text(".")
                .bold()
                .foregroundColor(.clear)
            ForEach(entries, id: \.id) { entry in
                VStack(alignment: .leading) {
                    HStack {
                        Text(entry.entryDescription)
                            .lineLimit(1)
                        Spacer()
                        Text(entry.projectName)
                            .lineLimit(1)
                    }
                    Spacer()
                    if type(of: entry) == TimeEntry.self {
                        Text((entry.end - entry.start).toString())
                    }
                }
                    .padding(3)
                    .background(entry.color(in: colorScheme))
        //            /// push View to stack when tapped
        //            .onTapGesture { showModal(for: entry, at: idx) }
        //            .matchedGeometryEffect(
        //                id: NamespaceModel(entryID: entry.id, dayIndex: idx),
        //                in: graphNamespace,
        //                isSource: model.selected == .none
        //            )
            }
        }
    }
}
