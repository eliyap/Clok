//
//  FlexibleGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FlexibleGraph: View {
    
    //MARK:- Properties
    /// tracks the `View`'s state, such as its mode and which `TimeEntry` is selected
    @StateObject var model = NewGraphModel()
    
    /// whether to show the `Mode` select menu
    @State var showSheet: Bool = false
    
    /// used for our `matchedGeometryEffect` animations
    @Namespace var namespace
    
    /// access CoreData `TimeEntry` storage
    @FetchRequest(
        entity: TimeEntry.entity(),
        sortDescriptors: []
    ) var entries: FetchedResults<TimeEntry>
    
    /// records the rows for `InfiniteScroll`
    @State var DayList = [0]
    
    /// light / dark mode
    @Environment(\.colorScheme) var mode
    
    @EnvironmentObject var data: TimeData
    
    //MARK:- Body
    var body: some View {
        /// switch out full screen modal when an entry is pushed
        if model.selected != .none {
            EntryFullScreenModal
        } else {
            #warning("placeholder UI")
            VStack {
                Button {
                    showSheet = true
                } label: {
                    Text("Transform!")
                }
                    .actionSheet(isPresented: $showSheet) { ModeSheet }
                NewGraph()
            }
        }
    }
}


