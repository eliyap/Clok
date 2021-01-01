//
//  ClokTableView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/1/21.
//  Copyright © 2021 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData

struct ClokTableView: UIViewRepresentable {
    
    static let cellResuseIdentifier = "Cell"
    
    var size: CGSize
    
    @Environment(\.managedObjectContext) private var moc
    
    typealias UIViewType = UITableView
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(ClokGraphCell.self, forCellReuseIdentifier: Self.cellResuseIdentifier)
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        /// nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(in: moc, size: size)
    }
    
    final class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var entries = [Int:[TimeEntry]]()
        var moc: NSManagedObjectContext
        var size: CGSize
        
        init(in context: NSManagedObjectContext, size: CGSize) {
            self.moc = context
            self.size = size
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
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let entries = self.entries[indexPath.section] ?? fetchEntries(at: indexPath.section)
            let cell = tableView.dequeueReusableCell(withIdentifier: ClokTableView.cellResuseIdentifier, for: indexPath) as! ClokGraphCell
            
//            entries.forEach{ assert(!$0.isFault) }
            
//            let view = TempDayGraph(entries: entries, start: Date().midnight.addingTimeInterval(-.day * Double(indexPath.section)), size: size)

            let myLayer = CAShapeLayer()
            cell.layer.backgroundColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
            myLayer.fillColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
            cell.layer.addSublayer(myLayer)
            

            cell.idx = indexPath.section
            cell.start = Date().midnight.addingTimeInterval(-.day * Double(indexPath.section))
            cell.constraints
                .first{$0.firstAttribute == .height && $0.relation == .equal}?
                .constant = size.height

            cell.setNeedsLayout()
            return cell
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            let cell = cell as! ClokTableCell
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

