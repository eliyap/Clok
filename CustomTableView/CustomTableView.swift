//
//  ContentView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI


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
    func rowForEntry(entry: TimeEntry?) -> Int {
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
    
    @State var myRow:Int = 0
    
    @EnvironmentObject var listRow:ListRow
    @EnvironmentObject var listPosition: ListPosition
    @EnvironmentObject private var zero:ZeroDate
    
    private let df = DateFormatter()
    
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
        df.setLocalizedDateFormatFromTemplate("MMMdd")
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
                    row: self.$myRow
                ).onReceive(self.listRow.$entry, perform: {
                    self.myRow = self.mutableData.rowForEntry(entry: $0)
                })
                
            }
            .navigationBarTitle(
                Text(
                    // poor man's switch statement
                    self.zero.frame == self.zero.pastSeven ?
                        weekLabels.pastSeven.rawValue :
                    self.zero.frame == self.zero.thisWeek ?
                        weekLabels.current.rawValue :
                    self.zero.frame == self.zero.lastWeek ?
                        weekLabels.last.rawValue :
                        self.df.string(from: self.zero.frame.start) +
                        " – " +
                        self.df.string(from: self.zero.frame.end)
                ),
                displayMode: .inline
            )
            .navigationBarItems(
                leading:prevWeekBtn().environmentObject(self.zero),
                trailing: nextWeekBtn().environmentObject(self.zero)
            )
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
        listPosition.position = max(target.pointee.y, 0)
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
