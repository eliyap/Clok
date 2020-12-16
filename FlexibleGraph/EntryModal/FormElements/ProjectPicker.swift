//
//  ProjectPicker.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 16/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectPicker: View {
    
    var projects: FetchedResults<Project>
    @Binding var selected: Project
    let dismiss: () -> Void
    let boundingWidth: CGFloat
    
    var body: some View {
        
        var width: CGFloat = 0
        var height: CGFloat = 0

        /// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
        return ZStack(alignment: .topLeading) {
            ForEach(projects, id: \.self) { project in
                Button {
                    selected = project
                    dismiss()
                } label: {
                    TagView(project: project)
                }
                    .alignmentGuide(.leading, computeValue: { tagSize in
                        /// checks if add this `View`'s width would cause row to exceed allowed width
                        if (abs(width - tagSize.width) > boundingWidth) {
                            /// if so, reset width tracker and ...
                            width = 0
                            /// ... wrap height to next row
                            height -= tagSize.height
                        }
                        
                        let offset = width
                        if project == projects.last {
                            width = 0
                        } else {
                            /// increment width tracker
                            width -= tagSize.width
                        }
                        return offset
                    })
                    .alignmentGuide(.top, computeValue: { tagSize in
                        let offset = height
                        if project == projects.last {
                            height = 0
                        }
                        return offset
                    })
            }
        }
    }
    
    /// A subview of a tag shown in a list. When tapped the tag will be removed from the array
    struct TagView: View {
        
        var project: Project
        
        var body: some View {
            Text(project.name)
                .padding(.leading, 2)
                .foregroundColor(.white)
                .padding(4)
                .background(project.wrappedColor)
                .padding(4)
        }
    }

}

