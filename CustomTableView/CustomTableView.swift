//
//  ContentView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

class TableRow : ObservableObject {
    @Published var row:Int = NSNotFound
}

class TimeEntryDataSource: TableViewDataSource, ObservableObject {
    
    @Published var mutableData = [TimeEntry]()
    
    func count() -> Int {
        return mutableData.count
    }
    
    func entryAt(_ path:IndexPath) -> TimeEntry {
        mutableData[path.row]
    }
    
    //MARK: Cell Lookup
    /// find the row holding this cell
    func rowForEntry(_ entry: TimeEntry?) -> Int {
        return mutableData.firstIndex(of: entry ?? TimeEntry()) ?? NSNotFound
    }
    
    init(_ someData: [TimeEntry]) {
        mutableData.append(contentsOf: someData)
    }
    func append(contentsOf data: [TimeEntry]) {
        mutableData.append(contentsOf: data)
    }
    func append(_ single: TimeEntry) {
        mutableData.append(single)
    }
}

struct CustomTableView: View, TableViewDelegate {
    
    @ObservedObject var mutableData = TimeEntryDataSource([])
    @State var inputField: String = ""
    @State var isScrolling: Bool = false
    
    @State var detailViewActive = false
    @State var selectedEntry = TimeEntry()
    @State var isLoading = false
    
    @State var tableRow = TableRow()
    
    @EnvironmentObject private var listRow: ListRow
    @EnvironmentObject private var zero: ZeroDate
    
//    func supplyMoreData() {
//        isLoading = true
//        var temp = [TimeEntry]()
//        for i in 0..<20 {
//            temp.append("New Item \(mutableData.count() + i)")
//        }
//        mutableData.append(contentsOf: temp)
//        isLoading = false
//    }
    
    init(_ entries:[TimeEntry]) {
        self.mutableData.append(contentsOf: entries)
        
        // using method from
        // https://stackoverflow.com/questions/51267284/ios-swift-how-to-have-dateformatter-without-year-for-any-locale
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                // makes the whole thing clickable
                NavigationLink(destination: DetailView(entry: self.selectedEntry), isActive: self.$detailViewActive) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .disabled(true)
                .hidden()
                
                TableView(
                    dataSource: self.mutableData as TableViewDataSource,
                    delegate: self,
                    tableRow: self.tableRow
                ).onReceive(self.listRow.$entry, perform: {
                    self.tableRow.row = self.mutableData.rowForEntry($0)
                })
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - TableViewDelegate Functions
    
    func onScroll(_ tableView: TableView, isScrolling: Bool) {
        withAnimation {
            self.isScrolling = isScrolling
        }
    }
    
    /// called when scrollDidEnd
    func scrollFinished(_ tableView: TableView, _ target: UnsafeMutablePointer<CGPoint>) {
        /// save the scroll position in case the user rotates
        /// which causes the view to be re-initialized
//        listPosition.position = max(target.pointee.y, 0)
    }
    
    func onAppear(_ tableView: TableView, at index: Int) {
//        if
//            // item loaded is within the last 5 items
//            index + 5 > self.mutableData.count() &&
//            // there is still more data to load
//            self.mutableData.count() < self.total &&
//            // not already loading something
//            !self.isLoading
//        {
//            print("*** NEED TO SUPPLY MORE DATA ***")
//            // might not need this method
//            self.supplyMoreData()
//        }
    }
    
    func onTapped(_ tableView: TableView, selected entry:TimeEntry?) {
        self.selectedEntry = entry ?? TimeEntry()
        self.detailViewActive = true
    }
}

struct CustomTableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTableView([])
    }
}
