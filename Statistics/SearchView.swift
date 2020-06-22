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
            ProjectListLink()
            DescriptionField()
        }
        .modifier(roundedList())
    }
    
    /**
     allows user to choose a different project
     */
    func ProjectListLink() -> some View {
        NavigationLink(destination: ProjectListView(
            search: self.$search,
            projects: self.data.projects().sorted()
        )
            .navigationBarTitle("Projects", displayMode: .inline)
            .navigationBarHidden(false)
        ) {
            HStack {
                Tab()
                Text(self.search.project.name)
            }
        }
        .modifier(fillRow())
    }
    
    func DescriptionField() -> some View {
        HStack {
            Tab()
            TextField(
                "No Description",
                text: self.$descriptionField,
                onEditingChanged: { _ in
                    self.search.byDescription = true
                },
                onCommit: {
                    /// only change description when user presses return
                    self.search.description = self.descriptionField
                }
            )
                .foregroundColor(
                    self.search.byDescription ?
                    Color.primary :
                    Color(UIColor.placeholderText
                ))
            Toggle(isOn: self.$search.byDescription) {
                EmptyView()
            }
            .border(Color.red)
        }
        .modifier(fillRow())
    }
    
    func Tab() -> some View {
        Rectangle()
            .frame(width: listLineInset)
            .foregroundColor(self.search.project.color)
    }
}
