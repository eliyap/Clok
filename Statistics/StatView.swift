//
//  StatView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    @State private var project = Project.any
    @State private var descriptionField: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    ProjectListLink()
                    HStack {
                        Rectangle()
                            .frame(width: listLineInset)
                            .foregroundColor(project.color)
                        TextField(
                            "No Description",
                            text: self.$descriptionField,
                            onCommit: {
                                /// only change description when user presses return
                                self.description = self.descriptionField
                            }
                        )
                        Text(self.description)
                        
                    }
                    .modifier(fillRow())
                }
                .modifier(roundedList())
                
                StatDisplayView(for: WeekTimeFrame(
                    start: self.zero.date,
                    entries: self.data.report.entries,
                    terms: SearchTerm(
                        project: self.project,
                        description: self.description,
                        byProject: true,
                        byDescription: false
                    )
                ))
                .navigationBarHidden(true)
                .navigationBarTitle("Summary", displayMode: .inline)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /**
     allows user to choose a different project
     */
    func ProjectListLink() -> some View {
        NavigationLink(destination: ProjectListView(
            chosen: self.$project,
            projects: self.data.projects().sorted()
        )
            .navigationBarTitle("Projects", displayMode: .inline)
            .navigationBarHidden(false)
        ) {
            HStack{
                Rectangle()
                    .frame(width: listLineInset)
                    .foregroundColor(project.color)
                Text(project.name)
                    .bold()
            }
        }
        .modifier(fillRow())
    }
}
