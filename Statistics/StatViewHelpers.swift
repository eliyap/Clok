//
//  StatViewHelpers.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/**
 gives a list nice rounded corners
 https://stackoverflow.com/questions/57945907/rounded-corners-in-swiftui-list-sections
 */
struct roundedList : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
    }
}

/**
 allows content to completely fill a List Row
 particularly useful if you want the colored tab to fill the leading section
 */
struct fillRow : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .edgesIgnoringSafeArea([.top, .bottom])
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
