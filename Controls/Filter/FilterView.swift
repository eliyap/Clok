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
            }
            .listStyle(PlainListStyle())
        }
        .padding([.leading, .trailing], listPadding)
    }
    
    /// wrapper around withAnimation, due to some scoping issue
    func exclude(_ project: ProjectLike) -> Void {
        withAnimation {
            _ = data.terms.projects.remove(at: data.terms.projects.firstIndex(where: {$0.wrappedID == project.wrappedID})!)
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
        ForEach(data.terms.projects, id: \.wrappedID) { project in
            HStack {
                Image(systemName: "largecircle.fill.circle")
                    .foregroundColor(project.wrappedColor)
                Text("\(project.wrappedName)")
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
        ForEach(excluded, id: \.wrappedID) { project in
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
    }
    
    var allProjects: [ProjectLike] {
        data.projects + [StaticProject.noProject]
    }
    
    var excluded: [ProjectLike] {
        allProjects
            .filter{!data.terms.contains(project: $0)}
            .sorted(by: {$0.wrappedName < $1.wrappedName})
    }
}
