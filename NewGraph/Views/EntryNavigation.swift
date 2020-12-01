//
//  EntryNavigation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryNavigation: View {
    
    @StateObject var model = NewGraphModel()
    @State var hasEntry: Bool = false
    @State var showSheet: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        Group {
            if model.selected != nil {
                Rectangle()
                    .foregroundColor(model.selected?.entry.color)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .matchedGeometryEffect(id: model.selected!, in: namespace)
                    
            } else {
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
            .environmentObject(model)
            .environment(\.namespace, namespace)
//            .onChange(of: model.selected?.entry) { entry in
//                self.hasEntry = entry != nil
//                print(hasEntry)
//            }
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
