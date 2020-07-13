//
//  ProjectButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectButton: View {
    @EnvironmentObject private var data: TimeData
    
    @State private var showSheet = false
    
    let radius = CGFloat(10)
    
    var body: some View {
        HStack {
            /// show Any Project as an empty circle
            Image(systemName: StaticProject.any == data.terms.project ? "circle" : "largecircle.fill.circle")
                .foregroundColor(StaticProject.any == data.terms.project ? Color.primary : data.terms.project.wrappedColor)
                .modifier(ButtonGlyph())
                .actionSheet(isPresented: $showSheet) { makeSheet() }
            Text("Project is \(data.terms.project.wrappedName)")
        }
        .onTapGesture {
            self.showSheet.toggle()
        }
    }
    
    func makeSheet() -> ActionSheet {
        let projects: [ProjectLike] = [StaticProject.any] + data.projects
        /// make a button for each project
        let projectBtns = projects.map { project in
            ActionSheet.Button.default(Text(project.wrappedName)) { () -> Void in
                self.data.terms.project = project
            }
        /// remember cancel button
        } + [ActionSheet.Button.cancel()]
        
        
        return ActionSheet(
            title: Text("Project"),
            buttons: projectBtns
        )
    }
}

struct ProjectButton_Previews: PreviewProvider {
    static var previews: some View {
        ProjectButton()
    }
}
