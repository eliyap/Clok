//
//  Poison.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/1/21.
//  Copyright © 2021 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData

final class ClokTableCell: UITableViewCell {
    var host: UIHostingController<AnyView>?
    var idx: Int?
    var start: Date?
}

struct ClokTableView: UIViewRepresentable {
    
    static let cellResuseIdentifier = "Cell"
    
    @Environment(\.managedObjectContext) var moc
    
    typealias UIViewType = UITableView
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(ClokTableCell.self, forCellReuseIdentifier: Self.cellResuseIdentifier)
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        /// nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(in: moc)
    }
    
    final class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var entries = [Int:[TimeEntry]]()
        var moc: NSManagedObjectContext
//        var controller: NSFetchedResultsController
        
        init(in context: NSManagedObjectContext) {
            self.moc = context
//            let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
//            req.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
//            let controller = NSFetchedResultsController(fetchRequest: req, managedObjectContext: moc, sectionNameKeyPath: <#T##String?#>, cacheName: <#T##String?#>)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
            req.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
            req.fetchLimit = 1
            do {
                let oldest = try moc.fetch(req) as! [TimeEntry]
                if oldest.isEmpty {
                    return 0
                } else {
                    return Int((Date() - oldest[0].start.midnight) / .day)
                }
            } catch {
                assert(false, "Failed to fetch!")
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            /// returns  number of days
            (Date() - Double(section) * .day).MMMdd
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            /// returns the number of entries in the day
//            let start = Date().midnight.advanced(by: -.day * Double(section))
//            let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
//            req.predicate = NSPredicate(format: "(start > %@) AND ( start < %@)", NSDate(start), NSDate(start + .day))
//            return try! moc.count(for: req)
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ClokTableView.cellResuseIdentifier, for: indexPath) as! ClokTableCell
            
            let entries = self.entries[indexPath.section] ?? fetchEntries(at: indexPath.section)
            let view = TempListView(entries: entries)
            
            if cell.host == nil {
                let controller = UIHostingController(rootView: AnyView(view))
                cell.host = controller
                
                let tableCellViewContent = controller.view!
                tableCellViewContent.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(tableCellViewContent)
                tableCellViewContent.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
                tableCellViewContent.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
                tableCellViewContent.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
                tableCellViewContent.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            } else {
                cell.host?.rootView = AnyView(view)
            }
            cell.setNeedsLayout()
            
            cell.idx = indexPath.section
            cell.start = Date().midnight.addingTimeInterval(-.day * Double(indexPath.section))
            return cell
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let cell = cell as! ClokTableCell
            let index = indexPath.section
            DispatchQueue.global(qos: .utility).async { [self] in
                entries[index - 1] = fetchEntries(at: index - 1)
                entries[index + 1] = fetchEntries(at: index + 1)
            }
        }
        
        func fetchEntries(at index: Int) -> [TimeEntry] {
            let start = Date().midnight.advanced(by: -.day * Double(index))
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
            req.predicate = NSPredicate(format: "(start > %@) AND ( start < %@)", NSDate(start), NSDate(start + .day))
            req.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
            req.returnsObjectsAsFaults = false
            return try! moc.fetch(req) as! [TimeEntry]
        }
    }
}

struct TempListView: View {
    var entries: [TimeEntry]
    var body: some View {
        VStack {
            ForEach(entries, id: \.id) { entry in
                Text(entry.projectName ?? StaticProject.NoProject.name)
            }
        }
    }
}
