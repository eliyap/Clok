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
    func titleForRow(row: Int) -> String
    func subtitleForRow(row: Int) -> String?
}

protocol TableViewDelegate {
    func heightForRow(_ tableView: TableView, at index: Int) -> CGFloat
    func onScroll(_ tableView: TableView, isScrolling: Bool) -> Void
    func onAppear(_ tableView: TableView, at index: Int) -> Void
    func onTapped(_ tableView: TableView, at index: Int) -> Void
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
        
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.delegate = context.coordinator
        uiView.dataSource = context.coordinator
        
        if context.coordinator.updateData(newData: self.dataSource) {
            uiView.reloadData()
        }
        
        // move to selected row, or none if out of bounds (including if NSNotFound)
        if row < uiView.numberOfRows(inSection: 0){
            uiView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
            
            // prevent table from infinitely updating itself
            listRow.row = NSNotFound
        }
    }
    
    //MARK: - Coordinator
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        
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
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mydata?.count() ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! TableViewCell

            if let dataSource = mydata {
                cell.heading.text = dataSource.titleForRow(row: indexPath.row)
                cell.subheading.text = dataSource.subtitleForRow(row: indexPath.row)
//                cell.bar.draw(CGRect(x: 0, y: 0, width: 100, height: 200))
                cell.accessoryType = .disclosureIndicator
                delegate?.onAppear(parent, at: indexPath.row)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.onTapped(parent, at: indexPath.row)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return self.delegate?.heightForRow(parent, at: indexPath.row) ?? 56.0
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
