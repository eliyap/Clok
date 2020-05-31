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
    
    @EnvironmentObject var listPosition: ListPosition
    // receives updates on the clicked time Entry from SpiralUI
    @Binding var row:Int
    @EnvironmentObject var listRow: ListRow
    
    func makeCoordinator() -> TableView.Coordinator {
        Coordinator(self, delegate: self.delegate)
    }
    
    func makeUIView(context: Context) -> UITableView {
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        
        // restore the saved scroll position
        tableView.setContentOffset(CGPoint(x: 0.0, y: listPosition.position), animated: false)
        
        // determines the offset of the thin grey line separating cells
        // currently the line completely cuts the tabs
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.delegate = context.coordinator
        uiView.dataSource = context.coordinator
        
        if context.coordinator.updateData(newData: self.dataSource) {
            uiView.reloadData()
        }
        
        // move to selected row, or none if out of bounds (NSNotFound is always out of bounds)
        if row < uiView.numberOfRows(inSection: 0){
            let idx = IndexPath(row: row, section: 0)
//            uiView.scrollToRow(at: idx, at: .top, animated: true)
            uiView.selectRow(at: idx, animated: true, scrollPosition: .top)
            uiView.deselectRow(at: idx, animated: true)
            // prevent table from infinitely updating itself
            listRow.entry = nil
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
        
        var previousCount = 0
        
        init(_ parent: TableView, delegate: TableViewDelegate?) {
            self.delegate = delegate
            self.parent = parent
        }
        
        // This function determines if the table should refresh. It keeps track of the count of items and
        // returns true if the new data has a different count. Ideally, you'd compare the count but also
        // compare the items. This is crucial to avoid redrawing the screen whenever it scrolls.
        func updateData(newData: TableViewDataSource) -> Bool {
            if newData.count() != previousCount {
                mydata = newData
                previousCount = newData.count()
                return true
            }
            return false
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // we only have 1 section
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // tells how many rows we have in the 1 and only section
            return mydata?.count() ?? 0
        }
        
        // returns the cell at the provided index
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! TableViewCell

            if let dataSource = mydata {
                // set the text if our 2 elements
                let entry = dataSource.entryAt(indexPath)
                cell.heading.text = entry.description
                cell.subheading.text = entry.project
                // set the color to the project color
                cell.tab.backgroundColor = entry.project_hex_color.uiColor()
                
                // no idea what this does
                delegate?.onAppear(parent, at: indexPath.row)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
//            print(mydata?.titleForRow(row: indexPath.row))
            delegate?.onTapped(parent, selected: mydata?.entryAt(indexPath))
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // hardcoded height removes bottom padding
            // to make tabs unbroken
            return 55
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            // something here?
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            self.delegate?.onScroll(parent, isScrolling: true)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            self.delegate?.onScroll(parent, isScrolling: false)
            self.delegate?.scrollFinished(parent, targetContentOffset)
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return nil
        }
        
    }
}
