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
    
    //MARK: Cell Details
    func titleForRow(row: Int) -> String {
        return mutableData[row].description
    }
    func subtitleForRow(row: Int) -> String? {
        return mutableData[row].project
    }
    func colorForRow(row: Int) -> UIColor {
        return mutableData[row].project_hex_color.uiColor()
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
    @State var detailViewRow = 0
    @State var isLoading = false
    
    @State var myRow:Int = 0
    
    @EnvironmentObject var listRow:ListRow
    @EnvironmentObject var listPosition: ListPosition
    
    let total = 100
    
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
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // makes the whole thing clickable
                NavigationLink(destination: DetailView(rowIndex: self.detailViewRow), isActive: self.$detailViewActive) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .disabled(true)
                .hidden()
                
                TableView(
                    dataSource: self.mutableData as TableViewDataSource,
                    delegate: self,
                    row: self.$myRow
                ).onReceive(listRow.$entry, perform: {
                    self.myRow = self.mutableData.rowForEntry(entry: $0)
                })
                .onDisappear() {
                    print("poof")
                }
                
                VStack{
                    Text("\(listPosition.position)") // debug
                    Text("\(self.myRow)")
                }
                
                }
            .navigationBarTitle("Entries")
            // prevents a weird white space when the title contracts when scrolling down
            .edgesIgnoringSafeArea(.top)
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
    
    func onTapped(_ tableView: TableView, at index: Int) {
        print("Tapped on record \(index)")
        self.detailViewRow = index
        self.detailViewActive.toggle()
    }
}

struct CustomTableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTableView([])
    }
}
