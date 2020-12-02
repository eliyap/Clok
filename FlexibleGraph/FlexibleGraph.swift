//
//  FlexibleGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FlexibleGraph: View {
    
    /// tracks the `View`'s state, such as its mode and which `TimeEntry` is selected
    @StateObject var model = NewGraphModel()
    
    /// whether to show the `Mode` select menu
    @State var showSheet: Bool = false
    
    /// used for our `matchedGeometryEffect` animations
    @Namespace var namespace
    
    var body: some View {
        if model.selected != .none {
            
        } else {
            
        }
    }
}


