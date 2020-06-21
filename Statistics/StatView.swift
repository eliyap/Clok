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
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    NavigationLink(destination: ProjectListView(
                        chosen: self.$project,
                        projects: self.data.projects().sorted()
                    )
                        .navigationBarTitle("Projects", displayMode: .inline)
                        .navigationBarHidden(false)
                    ) {
                        HStack{
                            Rectangle()
                                .frame(width: 15)
                                .foregroundColor(project.color)
                            Text(project.name)
                                .bold()
                        }
                        
                    }
                    .modifier(fillRow())
                }
                .modifier(roundedList())
                
                
                StatDisplayView(for: WeekTimeFrame(
                    start: self.zero.date,
                    entries: self.data.report.entries,
                    terms: SearchTerm(
                        project: .noProject,
                        description: "",
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
}
