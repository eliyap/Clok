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
    
    @State private var showingActionSheet = false
    
    let radius = CGFloat(10)
    
    var body: some View {
        Button(action: {
            self.showingActionSheet = true
        }) {
            Image(systemName: "circle.fill")
                .foregroundColor(data.terms.project.color)
                .modifier(ButtonGlyph())
        }
        .actionSheet(isPresented: $showingActionSheet) {
            /// make a button for each project
            var projectBtns = self.data.projects().map { project in
                ActionSheet.Button.default(Text(project.name)) { () -> Void in
                    self.data.terms.project = project
                }
            }
            /// remember cancel button
            projectBtns.append(.cancel())
            
            return ActionSheet(
                title: Text("Change background"),
                message: Text("Select a new color"),
                buttons: projectBtns
            )
        }
    }
}

struct ProjectButton_Previews: PreviewProvider {
    static var previews: some View {
        ProjectButton()
    }
}
