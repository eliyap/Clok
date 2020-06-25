//
//  SearchView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var data: TimeData
    @Binding var search: SearchTerm
    @State private var descriptionField: String = ""
    
    var body: some View {
        List{
            Section(header: Text("Filters")) {
                ProjectListLink()
                DescriptionField()
            }
            
        }
        .modifier(roundedList())
    }
    
    /**
     allows user to choose a different project
     */
    func ProjectListLink() -> some View {
        NavigationLink(destination: ProjectListView(
            search: self.$search,
            projects: self.data.projects()
        )
            .navigationBarTitle("Projects", displayMode: .inline)
            .navigationBarHidden(true)
        ) {
            HStack {
                Tab()
                Text(self.search.project.name)
                    .bold()
            }
        }
        .modifier(fillRow())
    }
    
    func DescriptionField() -> some View {
        HStack {
            Tab()
            /// toggle is designed to be beside some text, hence the nesting
//            Toggle(isOn: self.$search.byDescription) {
//                TextField(
//                    /// placeholder text
//                    "No Description",
//                    text: self.$descriptionField,
//                    onEditingChanged: { _ in
//                        /// if user edits description, turn on filtering for them
//                        self.search.byDescription = true
//                    },
//                    onCommit: {
//                        /// only change description when user presses return, instead of every keystroke (direct binding)
//                        self.search.description = self.descriptionField
//                    }
//                )
//                    /// grey out when description search is disabled
//                    .foregroundColor(
//                        self.search.byDescription ?
//                        Color.primary :
//                        Color(UIColor.placeholderText
//                    ))
//            }
        }
        .modifier(fillRow())
    }
    
    func Tab() -> some View {
        Rectangle()
            .frame(width: listLineInset)
            .foregroundColor(self.search.project.color)
    }
}
