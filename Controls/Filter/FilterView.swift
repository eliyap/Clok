//
//  FilterView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var data: TimeData
    
    var body: some View {
        ScrollView {
            Text("Filter")
                .bold()
                .font(.title)
            Section(header: Text("Include")) {
                ForEach(data.terms.projects, id: \.wrappedID) {  project in
                    HStack {
                        Image(systemName: "largecircle.fill.circle")
                        Text("\(project.wrappedName)")
                    }
                }
                ForEach(excluded, id: \.wrappedID) { project in
                    HStack {
                        Image(systemName: "circle")
                        Text("\(project.wrappedName)")
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var allProjects: [ProjectLike] {
        data.projects + [StaticProject.noProject]
    }
    
    var excluded: [ProjectLike] {
        allProjects.filter{ project in
            !data.terms.projects.contains(where: {project.wrappedID == $0.wrappedID})
        }
    }
}
