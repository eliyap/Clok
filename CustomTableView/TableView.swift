//
//  TableView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

protocol TableViewDataSource {
    func count() -> Int
    func entryAt(_ path:IndexPath) -> TimeEntry
    func boundIDs() -> (Int, Int)
    func pathFor(entry: TimeEntry?, relativeTo zero: Date) -> IndexPath
    func rowsIn(section: Int) -> Int
}

protocol TableViewDelegate {
    func onScroll(_ tableView: TableView, isScrolling: Bool) -> Void
    func onAppear(_ tableView: TableView, at index: Int) -> Void
    func onTapped(_ tableView: TableView, selected entry:TimeEntry?) -> Void
    func scrollFinished(_ tableView:TableView, _ target: UnsafeMutablePointer<CGPoint>) -> Void
}

struct TableView: UIViewRepresentable {
        
    var dataSource: TableViewDataSource
    var delegate: TableViewDelegate?
    
    let tableView = UITableView()
    
    // receives updates on the clicked time Entry from parent
    @ObservedObject var tableRow : TableRow
    
    func makeCoordinator() -> TableView.Coordinator {
        Coordinator(self, delegate: self.delegate)
    }
    
    func makeUIView(context: Context) -> UITableView {
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        
        // determines the offset of the thin grey line separating cells
        // this makes the line completely cuts the tabs
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.delegate = context.coordinator
        uiView.dataSource = context.coordinator
        
        if context.coordinator.updateData(newData: self.dataSource) {
            uiView.reloadData()
        }
        
        var rows = 0
        for idx in 0..<7 {
            rows += uiView.numberOfRows(inSection: idx)
        }
            
        // move to selected row, or none if out of bounds (NSNotFound will always be always out of bounds)
        if tableRow.path.row != NSNotFound {
            /// copy path value to lock it in, otherwise it will have changed by the time the async deselect fires
            let cellPath = tableRow.path
            uiView.selectRow(at: cellPath, animated: true, scrollPosition: .top)
            
            /// deselect after .5s, gives time for scroll to occur before fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                uiView.deselectRow(at: cellPath, animated: true)
            }
        }
    }
    
    //MARK: - Coordinator
    
    class Coordinator:
        NSObject,
        UITableViewDelegate,
        UITableViewDataSource
    {
        var parent: TableView

        var mydata: TableViewDataSource?
        var delegate: TableViewDelegate?
        
        /// save most recent first and last entry ID, so we can see if the data changed
        var previousBounds = (0, 0)
        
        init(_ parent: TableView, delegate: TableViewDelegate?) {
            self.delegate = delegate
            self.parent = parent
        }
        
        // This function determines if the table should refresh. It keeps track of the count of items and
        // returns true if the new data has a different count. Ideally, you'd compare the count but also
        // compare the items. This is crucial to avoid redrawing the screen whenever it scrolls.
        func updateData(newData: TableViewDataSource) -> Bool {
            if newData.boundIDs() != previousBounds {
                mydata = newData
                previousBounds = newData.boundIDs()
                return true
            }
            return false
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // 7 days in 1 week, + 1 because we can bridge midnight
            return 8
        }
        
        /// how many rows in this section (1 section being 1 day)
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            /// default to 0 rows (may not be reasonable!)
            print("section \(section) has \(mydata?.rowsIn(section: section)) rows")
            return mydata?.rowsIn(section: section) ?? 0
        }
        
        // returns the cell at the provided index
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CellIdentifier",
                for: indexPath
            ) as! TableViewCell
            
            if let dataSource = mydata {
                let entry = dataSource.entryAt(indexPath)
                
                cell.populate(entry: entry)
                
                // no idea what this does
                delegate?.onAppear(parent, at: indexPath.row)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.onTapped(parent, selected: mydata?.entryAt(indexPath))
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // hardcoded height removes bottom padding
            // to make tabs unbroken
            return 55
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            self.delegate?.onScroll(parent, isScrolling: true)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            self.delegate?.onScroll(parent, isScrolling: false)
            self.delegate?.scrollFinished(parent, targetContentOffset)
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Section \(section)"
        }
        
    }
}
