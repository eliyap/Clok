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
        VStack(alignment: .leading, spacing: .zero) {
            Text("Filter")
                .bold()
                .font(.title)
            SelectButtons
            List {
                Section {
                    Included
                    Excluded
                }
            }
            .listStyle(GroupedListStyle())
        }
        .padding(listPadding)
    }
    
    /// wrapper around withAnimation, due to some scoping issue
    func exclude(_ project: ProjectLike) -> Void {
        withAnimation {
            _ = data.terms.projects.remove(at: data.terms.projects.firstIndex(where: {$0.wrappedID == project.wrappedID})!)
        }
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
        .onMove(perform: {
            data.terms.projects.move(fromOffsets: $0, toOffset: $1)
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
    
    var SelectButtons: some View {
        HStack {
            Button {
                data.terms.projects = allProjects
            } label: {
                Text("Select All")
            }
            Spacer()
            Button {
                data.terms.projects.removeAll()
            } label: {
                Text("Deselect All")
            }
        }
    }
}
