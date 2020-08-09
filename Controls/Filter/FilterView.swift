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
    
    let listPadding: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Filter")
                .bold()
                .font(.title)
            HStack {
                Text("Select All")
                Spacer()
                Text("Deselect All")
            }
            List {
                Section {
                    ForEach(data.terms.projects, id: \.wrappedID) {
                        Included(project: $0)
                    }
                    .onMove(perform: {
                        data.terms.projects.move(fromOffsets: $0, toOffset: $1)
                    })
                    ForEach(excluded, id: \.wrappedID) {
                        Excluded(project: $0)
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .padding(listPadding)
    }
    
    func Included(project: ProjectLike) -> some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(project.wrappedColor)
            Text("\(project.wrappedName)")
        }
        .onTapGesture {
            withAnimation {
                data.terms.projects.append(project)
            }
        }
    }
    
    func Excluded(project: ProjectLike) -> some View {
        HStack {
            Image(systemName: "largecircle.fill.circle")
                .foregroundColor(project.wrappedColor)
            Text("\(project.wrappedName)")
            Spacer()
            Image(systemName: "line.horizontal.3")
        }
        .onTapGesture {
            withAnimation {
                _ = data.terms.projects.remove(at: data.terms.projects.firstIndex(where: {$0.wrappedID == project.wrappedID})!)
            }
        }
    }
    
    var allProjects: [ProjectLike] {
        data.projects + [StaticProject.noProject]
    }
    
    var excluded: [ProjectLike] {
        allProjects.filter{ project in
            !data.terms.projects.contains(where: {project.wrappedID == $0.wrappedID})
        }
        .sorted(by: {$0.wrappedName < $1.wrappedName})
    }
}
