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
    
    var body: some View {
        List {
            Text("Filter")
                .bold()
                .font(.title)
            Section(header: Text("Include")) {
                ForEach(allProjects, id: \.wrappedID) {
                    Text("\($0.wrappedName)")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var allProjects: [ProjectLike] {
        data.projects + [StaticProject.noProject]
    }
}
