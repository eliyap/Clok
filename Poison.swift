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
    
    var host: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    var idx: Int?
    var start: Date?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(host.view)
        
        /// set a constraint, value does not matter
        self.heightAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        self.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude).isActive = true
        host.view.translatesAutoresizingMaskIntoConstraints = false
//        host.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        host.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        host.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
}

struct ClokTableView: UIViewRepresentable {
    
    static let cellResuseIdentifier = "Cell"
    
    var size: CGSize
    
    @Environment(\.managedObjectContext) private var moc
    
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
        Coordinator(in: moc, size: size)
    }
    
    final class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var entries = [Int:[TimeEntry]]()
        var moc: NSManagedObjectContext
        var size: CGSize
        
        init(in context: NSManagedObjectContext, size: CGSize) {
            self.moc = context
            self.size = size
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
            let view = TempListView(entries: entries, size: size)
            
            cell.host.rootView = AnyView(view)
            
            cell.idx = indexPath.section
            cell.start = Date().midnight.addingTimeInterval(-.day * Double(indexPath.section))
            
            cell.constraints
                .first{$0.firstAttribute == .height && $0.relation == .equal}?
                .constant = cell.host.sizeThatFits(in: self.size).height
            cell.setNeedsLayout()
            
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
    
    /// light / dark mode
    @Environment(\.colorScheme) var colorScheme
    
    var entries: [TimeEntry]
    var size: CGSize
    
    var body: some View {
        VStack {
            ForEach(entries, id: \.id) { entry in
                VStack(alignment: .leading) {
                    HStack {
                        Text(entry.entryDescription)
                            .lineLimit(1)
                        Spacer()
                        Text(entry.projectName ?? StaticProject.NoProject.name)
                            .lineLimit(1)
                    }
//                    Spacer()
                    if type(of: entry) == TimeEntry.self {
                        Text(entry.duration.toString())
                    }
                }
                    .padding(3)
                    .background(entry.color(in: colorScheme))
            }
        }
        .frame(width: size.width)
        .border(Color.red)
    }
}
