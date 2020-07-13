//
//  ProjectListView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var data: TimeData
    @Binding var search: SearchTerm
    @Environment(\.presentationMode) var mode
    
    
    let projects: [Project]
    
    var body: some View {
        List {
            /// option to filter for Any Project
            self.button(for: StaticProject.any).modifier(fillRow())
            
            ForEach(self.projects, id: \.id ) { project in
                self.button(for: project).modifier(fillRow())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .modifier(roundedList())
    }
    
    func button(for project: ProjectLike) -> some View {
        Button(action: {
            data.terms.project = project
            search.project = project
            
            /// dismiss this view after project is selected
            self.mode.wrappedValue.dismiss()
        }) {
            HStack{
                Rectangle()
                    .frame(width: listLineInset)
                    .foregroundColor(project.wrappedColor)
                /// bold the chosen project
                if (project.wrappedName == search.project.wrappedName) {
                    Text(project.wrappedName)
                        .bold()
                } else {
                    Text(project.wrappedName)
                }
            }
        }
    }
}
