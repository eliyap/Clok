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
    func titleForRow(row: Int) -> String {
        return mutableData[row].description
    }
    func subtitleForRow(row: Int) -> String? {
        return mutableData[row].project
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
                    delegate: self
                )
                
                VStack{
                    Text("\(listPosition.position)") // debug
//                    Text("\(self.row.row)")
                }
                
            }
            .navigationBarTitle("UITableView")
            // prevents a weird white space when the title contracts when scrolling down
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    //MARK: - TableViewDelegate Functions
    
    func onScroll(_ tableView: TableView, isScrolling: Bool) {
        withAnimation {
            self.isScrolling = isScrolling
        }
    }
    
    // called when scrollDidEnd
    func scrollFinished(_ tableView: TableView, _ target: UnsafeMutablePointer<CGPoint>) {
        // save the scroll position in case the user rotates
        // which causes the view to be re-initialized
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
////            self.supplyMoreData()
//        }
    }
    
    func onTapped(_ tableView: TableView, at index: Int) {
        print("Tapped on record \(index)")
        self.detailViewRow = index
        self.detailViewActive.toggle()
    }
    
    // this could be a view modifier but I do not think there is a way to read the view modifier
    // from a UIViewRepresentable (yet).
    func heightForRow(_ tableView: TableView, at index: Int) -> CGFloat {
        return 64.0
    }
}

struct CustomTableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTableView([])
    }
}
