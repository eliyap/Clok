//
//  TagPicker.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TagPicker: View {
    
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) private var tags: FetchedResults<Tag>
    
    private var tagStrings: [String] {
        tags.map{$0.name}
    }
    
    /// tags selected by the user
    @Binding var selected: [String]
    
    /// the maximum width available for the `View` to consume
    let boundingWidth: CGFloat
    
    var body: some View {
        
        var width: CGFloat = 0
        var height: CGFloat = 0

        /// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
        return ZStack(alignment: .topLeading) {
            ForEach(tagStrings, id: \.self) { tag in
                Button {
                    select(tag: tag)
                } label: {
                    TagView(tag: tag, selected: selected)
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
                        if tag == tagStrings.last {
                            width = 0
                        } else {
                            /// increment width tracker
                            width -= tagSize.width
                        }
                        return offset
                    })
                    .alignmentGuide(.top, computeValue: { tagSize in
                        let offset = height
                        if tag == tagStrings.last {
                            height = 0
                        }
                        return offset
                    })
            }
        }
    }
    
    /// if tag is present, remove it. otherwise, insert it at the correct index to keep the array sorted
    func select(tag: String) -> Void {
        if let idx = selected.firstIndex(of: tag) {
            selected.remove(at: idx)
        } else {
            selected.insert(tag, at: selected.insertionIndex{$0<tag})
        }
    }
    
    struct TagView: View {
        
        @Environment(\.colorScheme) var colorScheme
        
        var tag: String
        let selected: [String]
        
        static let radius: CGFloat = 3.0
        
        var body: some View {
            Text(tag)
                .padding(.leading, 2)
//                .foregroundColor(
//                    project == selected
//                        ? .white
//                        : .gray
//                )
                .padding(4)
//                .background(color)
                .cornerRadius(Self.radius)
                .padding(4)
        }
    }
}
