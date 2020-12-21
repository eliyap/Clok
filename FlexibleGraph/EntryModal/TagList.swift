//
//  TaggerView.swift
//
//  Created by Alex Hay on 21/11/2020.
//  Adapted starting 9/12/2020.
// Simple interface for adding tags to an array in SwiftUI
// Example video: https://imgur.com/gallery/CcA1IXp
// alignmentGuide code from Asperi @ https://stackoverflow.com/a/58876712/11685049
// Original from Alex Hay @ https://gist.github.com/mralexhay/d16aab434b9d765c13b9180fb42aada9

import SwiftUI

/// A subview containing a list of all tags that are in the array. Tags flow onto the next line when wider than the view's width
struct TagList: View {
    
    var tags: [String]
    let boundingWidth: CGFloat
    
    var body: some View {
        
        var width: CGFloat = 0
        var height: CGFloat = 0

        /// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
        return ZStack(alignment: .topLeading) {
            if tags.isEmpty {
                TagView(tag: "+")
            }
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
            .foregroundColor(.primary)
            .font(.caption2)
            .padding(4)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(5)
            .padding(4)
    }
}
