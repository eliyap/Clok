//
//  EntryNavigation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryNavigation: View {
    
    @ObservedObject var model = NewGraphModel()
    @State var hasEntry: Bool = false
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack { /// swift is cursed. this makes the nav link work. don't know why
                NewGraph()
                NavigationLink(destination: Text(model.entry?.wrappedDescription ?? "Oops"), isActive: $hasEntry) {
                    EmptyView()
                }
            }
                .navigationBarTitle(Text("Text"), displayMode: .inline)
                .navigationBarItems(trailing: Button {
                    showSheet = true
                } label: {
                    Text("Transform!")
                })
                /// hide NavBar to prevent it changing size during scroll
//                .navigationBarHidden(true)
        }
            .environmentObject(model)
            .onChange(of: model.entry) { entry in
                self.hasEntry = entry != nil
                print(hasEntry)
            }
            .actionSheet(isPresented: $showSheet) { ModeSheet }
    }
}

// MARK:- ActionSheet
extension EntryNavigation {
    var ModeSheet: ActionSheet {
        ActionSheet(title: Text("Graph Mode"), buttons: [
            .default(Text("Day")) {
                withAnimation { model.mode = .dayMode }
            },
            .default(Text("Week")) {
                withAnimation { model.mode = .weekMode }
            },
            .default(Text("List")) {
                withAnimation { model.mode = .listMode }
            },
            .cancel()
        ])
    }
}
