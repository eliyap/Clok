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
    @Binding var chosen: Project
    let projects: [Project]
    
    var body: some View {
        List {
            /// option to filter for Any Project
            self.button(for: .any).modifier(fillRow())
            
            ForEach(self.projects, id: \.id ) { project in
                self.button(for: project).modifier(fillRow())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .modifier(roundedList())
    }
    
    func button(for project: Project) -> some View {
        Button(action: {
            self.chosen = project
        }) {
            HStack{
                Rectangle()
                    .frame(width: 15)
                    .foregroundColor(project.color)
                if (project.name == chosen.name) {
                    Text(project.name)
                        .bold()
                } else {
                    Text(project.name)
                }
            }
        }
    }
}
