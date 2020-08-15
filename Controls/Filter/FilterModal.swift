//
//  FilterModal.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FilterModal: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Include")) {
                    EmptyView()
                }
                Section(header: Text("Exclude")) {
                    EmptyView()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(
                leading: Text("Filter Entries").bold().font(.title),
                trailing: DoneButton
            )
        }
    }
    
    var DoneButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Done").bold()
        }
    }
}
