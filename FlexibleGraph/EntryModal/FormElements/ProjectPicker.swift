//
//  ProjectPicker.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 16/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectPicker: View {
    
    var tags: [String]
    let boundingWidth: CGFloat
    
    var body: some View {
        
        var width: CGFloat = 0
        var height: CGFloat = 0

        /// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                TagView(tag: tag)
                    .alignmentGuide(.leading, computeValue: { tagSize in
                        /// checks if add this `View`'s width would cause row to exceed allowed width
                        if (abs(width - tagSize.width) > boundingWidth) {
                            /// if so, reset width tracker and ...
                            width = 0
                            /// ... wrap height to next row
                            height -= tagSize.height
                        }
                        
                        let offset = width
                        if tag == tags.last ?? "" {
                            width = 0
                        } else {
                            /// increment width tracker
                            width -= tagSize.width
                        }
                        return offset
                    })
                    .alignmentGuide(.top, computeValue: { tagSize in
                        let offset = height
                        if tag == tags.last ?? "" {
                            height = 0
                        }
                        return offset
                    })
            }
        }
    }
}

/// A subview of a tag shown in a list. When tapped the tag will be removed from the array
struct TagView: View {
    
    var tag: String
    
    var body: some View {
        Text(tag.lowercased())
            .padding(.leading, 2)
            .foregroundColor(.white)
            .font(.caption2)
            .padding(4)
            .background(Color.blue.cornerRadius(5))
            .padding(4)
    }
}
