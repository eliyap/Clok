//
//  EntryNavigation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// wrapper to allow observable
final class _TimeEntry: ObservableObject {
    @Published var entry: TimeEntry? = nil
}

final class GraphModeInfo: ObservableObject {
    @Published var graphMode: EntryNavigation.GraphMode = .weekMode
}

struct EntryNavigation: View {
    
    @ObservedObject var ChosenEntry: _TimeEntry = _TimeEntry()
    @State var hasEntry: Bool = false
    @State var graphModeInfo: GraphModeInfo = GraphModeInfo()
    
    enum GraphMode: Int {
        case weekMode
        case dayMode
    }
    
    var body: some View {
        NavigationView {
            VStack { /// swift is cursed. this makes the nav link work. don't know why
                NewGraph()
                NavigationLink(destination: Text(ChosenEntry.entry?.wrappedDescription ?? "Oops"), isActive: $hasEntry) {
                    EmptyView()
                }
            }
                .navigationBarTitle(Text("Text"), displayMode: .inline)
            .navigationBarItems(trailing: Button {
                self.graphModeInfo.graphMode = .dayMode
            } label: {
                Text("Transform!")
            })
                /// hide NavBar to prevent it changing size during scroll
//                .navigationBarHidden(true)
        }
            
            .environmentObject(ChosenEntry)
            .environmentObject(graphModeInfo)
            .onChange(of: ChosenEntry.entry) { entry in
                self.hasEntry = entry != nil
                print(hasEntry)
            }
    }
}
