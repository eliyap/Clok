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
    @Binding var selected: ProjectLike
    let dismiss: () -> Void
    let boundingWidth: CGFloat
    
    var projectChoices: [ProjectLike] {
        projects.map{ProjectLike.project($0)} + [.special(.NoProject)]
    }
    
    var body: some View {
        
        var width: CGFloat = 0
        var height: CGFloat = 0

        /// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
        return ZStack(alignment: .topLeading) {
            ForEach(projectChoices, id: \.self) { project in
                Button {
                    selected = project
                    dismiss()
                } label: {
                    TagView(project: project, selected: selected)
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
                        if project == projectChoices.last {
                            width = 0
                        } else {
                            /// increment width tracker
                            width -= tagSize.width
                        }
                        return offset
                    })
                    .alignmentGuide(.top, computeValue: { tagSize in
                        let offset = height
                        if project == projectChoices.last {
                            height = 0
                        }
                        return offset
                    })
            }
        }
    }
    
    /// A subview of a tag shown in a list. When tapped the tag will be removed from the array
    struct TagView: View {
        
        @Environment(\.colorScheme) var colorScheme
        
        var project: ProjectLike
        let selected: ProjectLike
        
        static let radius: CGFloat = 3.0
        
        var body: some View {
            Text(project.name)
                .padding(.leading, 2)
                .foregroundColor(
                    project == selected
                        ? .white
                        : .gray
                )
                .padding(4)
                .background(color)
                .cornerRadius(Self.radius)
                .padding(4)
        }
        
        var color: Color {
            if project == selected {
                return project.color
            } else {
                switch colorScheme {
                case .light:
                    return UIColor.white.tinted(with: project.color)
                case .dark:
                    return UIColor.black.tinted(with: project.color)
                default:
                    fatalError("Unsupported ColorScheme!")
                }
            }
        }
    }

}

