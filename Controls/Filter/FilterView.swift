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
    @EnvironmentObject var bounds: Bounds
    @FetchRequest(entity: Project.entity(), sortDescriptors: []) var projects: FetchedResults<Project>
    let listPadding: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: listPadding) {
            Title
            
            List {
                Button {
                    withAnimation {
                        data.terms.projects = allProjects
                    }
                } label: {
                    Text("Select All")
                        .foregroundColor(.blue)
                }
                Button {
                    withAnimation {
                        data.terms.projects.removeAll()
                    }
                } label: {
                    Text("Deselect All")
                        .foregroundColor(.blue)
                }
                Included
                Excluded
                /// workaround for the Tab Page indicator cutting off the bottom of the list
                Text(" ")
            }
            .listStyle(PlainListStyle())
        }
        .padding([.leading, .trailing], listPadding)
    }
    
    /// wrapper around withAnimation, due to some scoping issue
    func exclude(_ project: ProjectLike) -> Void {
        withAnimation {
            _ = data.terms.projects.remove(at: data.terms.projects.firstIndex(where: {$0.id == project.id})!)
        }
    }
    
    var Title: some View {
        Text("Filter")
            .font(bounds.device == .iPhone && bounds.mode == .portrait
                ? .title2
                : .title
            )
            .bold()
    }
    
    var Included: some View {
        ForEach(data.terms.projects, id: \.id) { project in
            HStack {
                Image(systemName: "largecircle.fill.circle")
                    .foregroundColor(project.color)
                Text("\(project.name)")
                /// for some reason (possible dragon drop), `onMove` does not register on the iPhone
                if bounds.device != .iPhone {
                    Spacer()
                    Image(systemName: "line.horizontal.3")
                }
            }
            .onTapGesture {
                exclude(project)
            }
        }
        .onMove(perform: { source, destination in
            withAnimation {
                data.terms.projects.move(fromOffsets: source, toOffset: destination)
            }
        })
    }
    
    var Excluded: some View {
        ForEach(excluded, id: \.id) { project in
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(project.color)
                Text("\(project.name)")
            }
            .onTapGesture {
                withAnimation {
                    data.terms.projects.append(project)
                }
            }
        }
    }
    
    var allProjects: [ProjectLike] {
        projects
            .sorted(by: {$0.name < $1.name})
            .map{ProjectLike.project($0)}
            + [ProjectLike.special(.NoProject)]
    }
    
    var excluded: [ProjectLike] {
        allProjects
            .filter{!data.terms.contains(project: $0)}
            .sorted(by: {$0.name < $1.name})
    }
}
