//
//  ContentView.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/4/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import SwiftUI

class TableRow : ObservableObject {
    @Published var path = IndexPath(row: NSNotFound, section: 0)
}

class TimeEntryDataSource: TableViewDataSource, ObservableObject {
    
    @ObservedObject var zero: ZeroDate
    @Published var mutableData = [TimeEntry]()
    
    func midnightFor(section: Int) -> Date {
        let cal = Calendar.current
        /// get n'th day from zero date (set to midnight)
        return cal.startOfDay(for: zero.date) + Double(section) * dayLength
    }
    
    func count() -> Int {
        return mutableData.count
    }
    
    func entryAt(_ path:IndexPath) -> TimeEntry {
        let idx = path.row +
        (mutableData.firstIndex(where: {$0.start > midnightFor(section: path.section)}) ?? 0)
        return mutableData[idx]
    }
    
    /// for reloading purposes, check the first and last ID for changes
    func boundIDs() -> (Int, Int) {
        (mutableData.first?.id ?? NSNotFound, mutableData.last?.id ?? NSNotFound)
    }
    
    //MARK: Cell Lookup
    /// find the row holding this cell
    func pathFor(entry: TimeEntry?, relativeTo zero: Date) -> IndexPath {
        guard
            let entry = entry,
            let row = mutableData.firstIndex(of: entry)
        else {
            return IndexPath(row: NSNotFound, section: 0)
        }
        
        let cal = Calendar.current
        let zeroMN = cal.startOfDay(for: zero)
        
        /// find which day section this falls under
        let section = Int((entry.start - zeroMN) / dayLength)
        
        /// and the first entry to fall on that day
        guard let firstRowOfSection = mutableData.firstIndex(where: {
            $0.start > cal.startOfDay(for: entry.start)
        }) else {
            return IndexPath(row: NSNotFound, section: 0)
        }
        
        return IndexPath(row: row - firstRowOfSection, section: section)
    }
    
    func rowsIn(section: Int) -> Int {
        mutableData.within(
            interval: dayLength,
            of: midnightFor(section: section)
        ).count
    }
    
    init(data someData: [TimeEntry], zero zero_ : ZeroDate) {
        zero = zero_
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
    
    @ObservedObject var mutableData = TimeEntryDataSource(data: [], zero: ZeroDate())
    
    /// clone of environment object that we pass to the tableview
    @State private var zeroClone = ZeroDate()
    
    @State var inputField: String = ""
    @State var isScrolling: Bool = false
    
    @State var detailViewActive = false
    @State var selectedEntry = TimeEntry()
    @State var isLoading = false
    
    @State var tableRow = TableRow()
    
    @EnvironmentObject private var listRow: ListRow
    @EnvironmentObject private var zero: ZeroDate
        
    init(_ entries:[TimeEntry]) {
        /// - IMPORTANT: entries must be sorted chronologically by start date (earliest start -> latest start)
        mutableData = TimeEntryDataSource(
            data: entries.sorted(by: {$0.start < $1.start}),
            zero: zeroClone
        )
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
                )
                /// abuse onReceive to pass environment row information down
                .onReceive(self.listRow.$entry, perform: {
                    self.tableRow.path = self.mutableData.pathFor(entry: $0, relativeTo: self.zero.date)
                })
                /// abuse onReceive to pass zeroDate down
                .onReceive(self.zero.$date, perform: {
                    self.zeroClone.date = $0
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
