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
    
    @ObservedObject private var zero: ZeroDate
    @Published var mutableData = [TimeEntry]()
    private let df = DateFormatter()
    
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
    func pathFor(entry: TimeEntry?) -> IndexPath {
        guard
            let entry = entry,
            let row = mutableData.firstIndex(of: entry)
        else {
            return IndexPath(row: NSNotFound, section: 0)
        }
        
        let cal = Calendar.current
        let zeroMN = cal.startOfDay(for: zero.date)
        
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
    
    /// number of rows in specified section (zero indexed)
    func rowsIn(section: Int) -> Int {
        return mutableData.within(
            interval: dayLength,
            of: midnightFor(section: section)
        ).count
    }
    
    func headerFor(section: Int) -> String {
        let cal = Calendar.current
        let currentYear = cal.component(.year, from: Date())
        let zeroYear = cal.component(.year, from: zero.date)
        
        /// day of week, day of month, MMM
        return [
            midnightFor(section: section).shortWeekday(),
            df.string(from: midnightFor(section: section)),
            /// plus optional YYYY if it is not current year
            ((currentYear == zeroYear) ? "" : "\(zeroYear)")
        ].joined(separator: " ")
    }
    
    func numberOfSections() -> Int {
        let cal = Calendar.current
        guard let first = mutableData.first?.start, let last = mutableData.last?.start else {
            return 0
        }
        /// if everything is on the same day, 1 section, etc.
        return Int((
            cal.startOfDay(for: last) - cal.startOfDay(for: first)
        ) / dayLength) + 1
    }
    
    init(data someData: [TimeEntry], zero zero_ : ZeroDate) {
        zero = zero_
        mutableData.append(contentsOf: someData
            .within(interval: weekLength, of: zero.date)
            /// - IMPORTANT: entries must be sorted chronologically by start date (earliest start -> latest start)
            .sorted(by: {$0.start < $1.start})
        )
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    func append(contentsOf data: [TimeEntry]) {
        mutableData.append(contentsOf: data)
    }
    func append(_ single: TimeEntry) {
        mutableData.append(single)
    }
}

struct CustomTableView: View, TableViewDelegate {
    
    @State var inputField: String = ""
    @State var isScrolling: Bool = false
    
    @State var detailViewActive = false
    @State var selectedEntry = TimeEntry()
    @State var isLoading = false
    
    /// clone of environment object that we pass to the tableview
    @State private var zeroClone = ZeroDate()
    @State var tableRow = TableRow()
    
    @EnvironmentObject private var listRow: ListRow
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject private var data: TimeData
        
    init(_ entries:[TimeEntry]) {
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                TableView(
                    dataSource: TimeEntryDataSource(
                        data: self.data.report.entries.matching(data.terms),
                        zero: zeroClone
                    ) as TableViewDataSource,
                    delegate: self,
                    row: self.listRow
                )
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
